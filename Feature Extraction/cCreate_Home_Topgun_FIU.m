clear all

%%

folder_fiu = 'FIU/Processed/' ;

home_folder{1} = dir( 'FIU/home/topgun' ) ;

% [ts in ns] [pid] [process] [lba] [size in 512 Bytes blocks] [Write or Read] [major device number] [minor device number] [MD5 per 512 Bytes]

ts = [ ] ;
lba = [ ] ;
block_size = [ ] ;
read = [ ] ;
write = [ ] ;

count_read_bin_30mnt = [ ] ;
size_read_bin_30mnt = [ ] ;
sl_read_bin_30mnt = [ ] ;
burst_read_bin_30mnt = [ ] ;
gini_read_bin_30mnt = [ ] ;
cad_read_bin_30mnt = [ ] ;

count_write_bin_30mnt = [ ] ;
size_write_bin_30mnt = [ ] ;
sl_write_bin_30mnt = [ ] ;
burst_write_bin_30mnt = [ ] ;
gini_write_bin_30mnt = [ ] ;
cad_write_bin_30mnt = [ ] ;

home_idle_bin_30mnt = [ ] ;
gini_bin_30mnt = [ ] ;

% for each home folder
for i_folder = 1 : numel( home_folder )
    % for each file in the home folder
    for i_file = 1 : numel( home_folder{i_folder} )
        % if the file has something in it
        if home_folder{ i_folder }( i_file ).bytes > 0
            
            %%% select current file
            file_temp = [home_folder{ i_folder }( i_file ).folder '/' home_folder{ i_folder }( i_file ).name] ;
            %%%
            
            %%% collect data from current file
            disp(['Scanning data'])
            fileID = fopen(file_temp) ;
            data = textscan(fileID , '%s' , 1e10 , 'Delimiter' , '|' ) ;
            fclose(fileID) ;
            disp(['Done scanning data'])
            
            disp(['Splitting data'])
            data_split = split( data{1} , ' ' ) ;
            disp(['Done splitting data'])
            
            disp(['Collecting data'])
            ts_temp = cellfun(@str2num , data_split( : , 1 )) ;
            lba_temp = cellfun(@str2num , data_split( : , 4 )) ;
            block_size_temp = cellfun(@str2num , data_split( : , 5 )) * 512 ;
            read_temp = strcmpi( data_split( : , 6 ) , 'R' ) ;
            write_temp = read_temp ~= 1 ;
            disp(['Done collecting data'])
            
            % make sure data is sorted by timestamp
            [~ , i_sort] = sort(ts_temp , 'ascend') ;
            ts_temp = ts_temp(i_sort) ;
            lba_temp = lba_temp(i_sort) ;
            block_size_temp = block_size_temp(i_sort) ;
            read_temp = read_temp(i_sort) ;
            write_temp = write_temp(i_sort) ;
            %
            
            % subtract initial timesptamp. convert timestamp from nsec to mnt
            ts_0 = ts_temp(1) ;
            ts_temp = ts_temp - ts_0 ;
            ts_mnt = ts_temp / 1e9 / 60 ;
            %
            %%%
            
            %%% Create 30 mnt  bins.
            bin_30_mnt = [0 : ceil( ts_mnt(end) / 30 )-1 ; 1 : ceil( ts_mnt(end) / 30 )]*30 ;
            bin_30_mnt(end) = bin_30_mnt(end) + 0.1 ;
            %%%
            
            %%% Determine whicn bin the rows fall in.
            i_fall = ts_mnt >= bin_30_mnt(1,:) & ts_mnt < bin_30_mnt(2,:) ;
            %%%
            
            % for each bin
            for i_bin_30mnt = 1 : size(i_fall,2)
                
                %%% bin data
                ts_bin_30mnt = ts_mnt(i_fall(: , i_bin_30mnt) , 1) ;
                
                lba_bin_30mnt = lba_temp(i_fall(: , i_bin_30mnt) , 1) ;
                count_bin_30mnt = length(lba_bin_30mnt) ;
                [lba_unique_bin_30mnt , ~] = unique( lba_bin_30mnt ) ;
                
                read_bin_30mnt = read_temp(i_fall(: , i_bin_30mnt) , 1) ;
                read_size_bin_30mnt = block_size_temp(i_fall(: , i_bin_30mnt) , 1) .* read_bin_30mnt ;
                lba_read_bin_30mnt = lba_bin_30mnt(read_bin_30mnt==1) ;
                count_read_bin_30mnt_temp = length(lba_read_bin_30mnt) ;
                [lba_unique_read_bin_30mnt , ~ , i_lba_read_repeat] = unique( lba_read_bin_30mnt ) ;
                count_lba_unique_read_bin_30mnt = accumarray( i_lba_read_repeat , 1) ;
                
                write_bin_30mnt = write_temp(i_fall(: , i_bin_30mnt) , 1) ;
                write_size_bin_30mnt = block_size_temp(i_fall(: , i_bin_30mnt) , 1) .* write_bin_30mnt ;
                lba_write_bin_30mnt = lba_bin_30mnt(write_bin_30mnt==1) ;
                count_write_bin_30mnt_temp = length(lba_write_bin_30mnt) ;
                [lba_unique_write_bin_30mnt , ~ , i_lba_write_repeat] = unique( lba_write_bin_30mnt ) ;
                count_lba_unique_write_bin_30mnt = accumarray( i_lba_write_repeat , 1) ;
                %%%
                
                %%% binned read features
                % count
                count_read_bin_30mnt = [count_read_bin_30mnt ; count_read_bin_30mnt_temp] ;
                %
                
                % size
                size_read_bin_30mnt = [size_read_bin_30mnt ; mean(read_size_bin_30mnt)] ;
                %
                
                % gini
                disp(['Calculating gini_read'])
                p_lba_unique_read = count_lba_unique_read_bin_30mnt / count_read_bin_30mnt_temp ;
                gini_read_bin_30mnt = [gini_read_bin_30mnt ; p_lba_unique_read' * (1-p_lba_unique_read) ] ;
                disp(['Done calculating gini_read'])
                %
                
                % sl_read
                disp(['Calculating sl_read'])
                
                w = lba_bin_30mnt .* read_bin_30mnt ;
                
                sl_temp = mean( diff( find([[0 diff(w')] ~= 8 1]) ) ) ;
                
                sl_read_bin_30mnt = [sl_read_bin_30mnt ; sl_temp] ;
                
                disp(['Done calculating sl_read'])
                %
                
                % burst_read
                ts_1min_bin = [(min(ts_bin_30mnt) : max(ts_bin_30mnt)) ; (min(ts_bin_30mnt) : max(ts_bin_30mnt))+1] ;
                num_read_calls_1min_bin = sum( (ts_bin_30mnt >= ts_1min_bin(1,:) & ts_bin_30mnt < ts_1min_bin(2,:)).*read_bin_30mnt , 1) ;
                burst_temp = var(num_read_calls_1min_bin) / mean(num_read_calls_1min_bin) ;
                burst_temp(isnan(burst_temp)) = 0 ;
                burst_read_bin_30mnt = [burst_read_bin_30mnt ; burst_temp] ;
                %
                
                % cad_read
                disp(['Calculating cad_read'])
                
                cad_temp = mean(abs(diff(lba_read_bin_30mnt))) ;
                cad_temp(isnan(cad_temp)) = 0 ;
                cad_read_bin_30mnt = [cad_read_bin_30mnt ; cad_temp] ;
                
                disp(['Done calculating cad_read'])
                %
                %%%
                
                %%% binned write features
                % count
                count_write_bin_30mnt = [count_write_bin_30mnt ; count_write_bin_30mnt_temp] ;
                %
                
                % size
                size_write_bin_30mnt = [size_write_bin_30mnt ; mean(write_size_bin_30mnt)] ;
                %
                
                % gini
                disp(['Calculating gini_write'])
                p_lba_unique_write = count_lba_unique_write_bin_30mnt / count_write_bin_30mnt_temp ;
                gini_write_bin_30mnt = [gini_write_bin_30mnt ; p_lba_unique_write' * (1-p_lba_unique_write) ] ;
                disp(['Done calculating gini_write'])
                %
                
                % sl_write
                disp(['Calculating sl_write'])
                
                w = lba_bin_30mnt .* write_bin_30mnt ;
                
                sl_temp = mean( diff( find([[0 diff(w')] ~= 8 1]) ) ) ;
                
                sl_write_bin_30mnt = [sl_write_bin_30mnt ; sl_temp] ;
                
                disp(['Done calculating sl_write'])
                %
                
                % burst_write
                ts_1min_bin = [(min(ts_bin_30mnt) : max(ts_bin_30mnt)) ; (min(ts_bin_30mnt) : max(ts_bin_30mnt))+1] ;
                num_write_calls_1min_bin = sum( (ts_bin_30mnt >= ts_1min_bin(1,:) & ts_bin_30mnt < ts_1min_bin(2,:)).*write_bin_30mnt , 1) ;
                burst_temp = var(num_write_calls_1min_bin) / mean(num_write_calls_1min_bin) ;
                burst_temp(isnan(burst_temp)) = 0 ;
                burst_write_bin_30mnt = [burst_write_bin_30mnt ; burst_temp] ;
                %
                
                % cad_write
                disp(['Calculating cad_write'])
                
                cad_temp = mean(abs(diff(lba_write_bin_30mnt))) ;
                cad_temp(isnan(cad_temp)) = 0 ;
                cad_write_bin_30mnt = [cad_write_bin_30mnt ; cad_temp] ;
                
                disp(['Done calculating cad_write'])
                %
                %%%
                
                disp(['Bin ' num2str(i_bin_30mnt) ' of ' num2str(size(i_fall,2)) , ' complete.'])
                
            end
            
        end
        
        [i_folder / numel(home_folder) * 100 i_file / numel(home_folder{i_folder}) * 100]
        
    end
    
end

save([folder_fiu 'home/topgun_fiu_data.mat'] , ...
    'count_read_bin_30mnt' , ...
    'size_read_bin_30mnt' , ...
    'sl_read_bin_30mnt' , ...
    'burst_read_bin_30mnt' , ...
    'gini_read_bin_30mnt' , ...
    'cad_read_bin_30mnt' , ...
    'count_write_bin_30mnt' , ...
    'size_write_bin_30mnt' , ...
    'sl_write_bin_30mnt' , ...
    'burst_write_bin_30mnt' , ...
    'gini_write_bin_30mnt' , ...
    'cad_write_bin_30mnt')

