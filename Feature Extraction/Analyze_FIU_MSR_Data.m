
clear all

%% Collect FIU data

clear variable
variable{1} = 'Read Count' ;
variable{2} = 'Read Size' ;
variable{3} = 'Read Burst' ;
variable{4} = 'Read Distance' ;

variable{5} = 'Write Count' ;
variable{6} = 'Write Size' ;
variable{7} = 'Write Burst' ;
variable{8} = 'Write Distance' ;

variable = variable' ;
variable_original = variable ;

% [count_read size_read sl_read cad_read count_write size_write sl_write cad_write]

%%% FIU Home Data
fiu_home_folder = [ 'FIU/Processed/home/' ] ;

homes_fiu_data = importdata([fiu_home_folder 'homes_fiu_data.mat']) ;
casa_fiu_data = importdata([fiu_home_folder 'casa_fiu_data.mat']) ;
ikki_fiu_data = importdata([fiu_home_folder 'ikki_fiu_data.mat']) ;
topgun_fiu_data = importdata([fiu_home_folder 'topgun_fiu_data.mat']) ;

fiu_home_data = [casa_fiu_data.count_read_bin_30mnt casa_fiu_data.size_read_bin_30mnt casa_fiu_data.burst_read_bin_30mnt casa_fiu_data.cad_read_bin_30mnt ...
    casa_fiu_data.count_write_bin_30mnt casa_fiu_data.size_write_bin_30mnt casa_fiu_data.burst_write_bin_30mnt casa_fiu_data.cad_write_bin_30mnt ; ...
    homes_fiu_data.count_read_bin_30mnt homes_fiu_data.size_read_bin_30mnt homes_fiu_data.burst_read_bin_30mnt homes_fiu_data.cad_read_bin_30mnt ...
    homes_fiu_data.count_write_bin_30mnt homes_fiu_data.size_write_bin_30mnt homes_fiu_data.burst_write_bin_30mnt homes_fiu_data.cad_write_bin_30mnt ; ...
    ikki_fiu_data.count_read_bin_30mnt ikki_fiu_data.size_read_bin_30mnt ikki_fiu_data.burst_read_bin_30mnt ikki_fiu_data.cad_read_bin_30mnt ...
    ikki_fiu_data.count_write_bin_30mnt ikki_fiu_data.size_write_bin_30mnt ikki_fiu_data.burst_write_bin_30mnt ikki_fiu_data.cad_write_bin_30mnt ; ...
    topgun_fiu_data.count_read_bin_30mnt topgun_fiu_data.size_read_bin_30mnt topgun_fiu_data.burst_read_bin_30mnt topgun_fiu_data.cad_read_bin_30mnt ...
    topgun_fiu_data.count_write_bin_30mnt topgun_fiu_data.size_write_bin_30mnt topgun_fiu_data.burst_write_bin_30mnt topgun_fiu_data.cad_write_bin_30mnt] ;

fiu_home_data(isnan(fiu_home_data)) = 0 ;

[N_fiu_home , P_fiu_home] = size(fiu_home_data) ;
fiu_home_data = [fiu_home_data ones(N_fiu_home,1)] ;
%%%

%%% FIU Web Data
fiu_web_folder = [ 'FIU/Processed/web/' ] ;

online_fiu_data = importdata([fiu_web_folder 'online_fiu_data.mat']) ;
webusers_fiu_data = importdata([fiu_web_folder 'webusers_fiu_data.mat']) ;

fiu_web_data = [online_fiu_data.count_read_bin_30mnt online_fiu_data.size_read_bin_30mnt online_fiu_data.burst_read_bin_30mnt online_fiu_data.cad_read_bin_30mnt ...
    online_fiu_data.count_write_bin_30mnt online_fiu_data.size_write_bin_30mnt online_fiu_data.burst_write_bin_30mnt online_fiu_data.cad_write_bin_30mnt ; ...
    webusers_fiu_data.count_read_bin_30mnt webusers_fiu_data.size_read_bin_30mnt webusers_fiu_data.burst_read_bin_30mnt webusers_fiu_data.cad_read_bin_30mnt ...
    webusers_fiu_data.count_write_bin_30mnt webusers_fiu_data.size_write_bin_30mnt webusers_fiu_data.burst_write_bin_30mnt webusers_fiu_data.cad_write_bin_30mnt] ;

fiu_web_data(isnan(fiu_web_data)) = 0 ;

[N_fiu_web , P_fiu_web] = size(fiu_web_data) ;
fiu_web_data = [fiu_web_data 2*ones(N_fiu_web,1)] ;
%%%

%%% FIU Mail Data
fiu_mail_folder = [ 'FIU/Processed/mail/' ] ;

mail_webmail_data = importdata([fiu_mail_folder 'webmail_fiu_data.mat']) ;

fiu_mail_data = [mail_webmail_data.count_read_bin_30mnt mail_webmail_data.size_read_bin_30mnt  mail_webmail_data.burst_read_bin_30mnt mail_webmail_data.cad_read_bin_30mnt ...
    mail_webmail_data.count_write_bin_30mnt mail_webmail_data.size_write_bin_30mnt mail_webmail_data.burst_write_bin_30mnt mail_webmail_data.cad_write_bin_30mnt] ;

fiu_mail_data(isnan(fiu_mail_data)) = 0 ;

[N_fiu_mail , P_fiu_mail] = size(fiu_mail_data) ;
fiu_mail_data = [fiu_mail_data 3*ones(N_fiu_mail,1)] ;
%%%

%%% All FIU Data
fiu_data = [fiu_home_data ; fiu_web_data ; fiu_mail_data] ;

[N_fiu , P_fiu] = size( fiu_data( : , 1 : end - 1) ) ;

i_shuffle_fiu = randperm( N_fiu , N_fiu ) ;

fiu_data = fiu_data( i_shuffle_fiu , :) ;
%%%

fiu_data_original = fiu_data ;
fiu_home_data_original = fiu_home_data ;
fiu_web_data_original = fiu_web_data ;
fiu_mail_data_original = fiu_mail_data ;

%% Collect MSR data

%%% MSR Home Data
msr_home_folder = [ 'MS/Processed/home/' ] ;

msr_home_data = importdata([msr_home_folder 'home_full_MSR_30min.csv']) ;
msr_home_data = split( msr_home_data , ',' ) ;

msr_home_count_read_bin_30mnt = cellfun(@str2num , msr_home_data( : , 2 )) ;
msr_home_size_read_bin_30mnt = cellfun(@str2num , msr_home_data( : , 3 )) ;
msr_home_sl_read_bin_30mnt = cellfun(@str2num , msr_home_data( : , 4 )) ;
msr_home_burst_read_bin_30mnt = cellfun(@str2num , msr_home_data( : , 5 )) ;
msr_home_cad_read_bin_30mnt = cellfun(@str2num , msr_home_data( : , 6 )) ;

msr_home_count_write_bin_30mnt = cellfun(@str2num , msr_home_data( : , 7 )) ;
msr_home_size_write_bin_30mnt = cellfun(@str2num , msr_home_data( : , 8 )) ;
msr_home_sl_write_bin_30mnt = cellfun(@str2num , msr_home_data( : , 9 )) ;
msr_home_burst_write_bin_30mnt = cellfun(@str2num , msr_home_data( : , 10 )) ;
msr_home_cad_write_bin_30mnt = cellfun(@str2num , msr_home_data( : , 11 )) ;

msr_home_data = [msr_home_count_read_bin_30mnt msr_home_size_read_bin_30mnt msr_home_burst_read_bin_30mnt msr_home_cad_read_bin_30mnt ...
    msr_home_count_write_bin_30mnt msr_home_size_write_bin_30mnt msr_home_burst_write_bin_30mnt msr_home_cad_write_bin_30mnt] ;

msr_home_data(isnan(msr_home_data)) = 0 ;

[N_msr_home , P_msr_home] = size(msr_home_data) ;
msr_home_data = [msr_home_data ones(N_msr_home,1)] ;
%%%

%%% MSR Web Data
msr_web_folder = [ 'MS/Processed/web/' ] ;

msr_web_data = importdata([msr_web_folder 'web_full_MSR_30min.csv']) ;
msr_web_data = split( msr_web_data , ',' ) ;

msr_web_count_read_bin_30mnt = cellfun(@str2num , msr_web_data( : , 2 )) ;
msr_web_size_read_bin_30mnt = cellfun(@str2num , msr_web_data( : , 3 )) ;
msr_web_sl_read_bin_30mnt = cellfun(@str2num , msr_web_data( : , 4 )) ;
msr_web_burst_read_bin_30mnt = cellfun(@str2num , msr_web_data( : , 5 )) ;
msr_web_cad_read_bin_30mnt = cellfun(@str2num , msr_web_data( : , 6 )) ;

msr_web_count_write_bin_30mnt = cellfun(@str2num , msr_web_data( : , 7 )) ;
msr_web_size_write_bin_30mnt = cellfun(@str2num , msr_web_data( : , 8 )) ;
msr_web_sl_write_bin_30mnt = cellfun(@str2num , msr_web_data( : , 9 )) ;
msr_web_burst_write_bin_30mnt = cellfun(@str2num , msr_web_data( : , 10 )) ;
msr_web_cad_write_bin_30mnt = cellfun(@str2num , msr_web_data( : , 11 )) ;

msr_web_data = [msr_web_count_read_bin_30mnt msr_web_size_read_bin_30mnt msr_web_burst_read_bin_30mnt msr_web_cad_read_bin_30mnt ...
    msr_web_count_write_bin_30mnt msr_web_size_write_bin_30mnt msr_web_burst_write_bin_30mnt msr_web_cad_write_bin_30mnt] ;

msr_web_data(isnan(msr_web_data)) = 0 ;

[N_msr_web , P_msr_web] = size(msr_web_data) ;
msr_web_data = [msr_web_data 2*ones(N_msr_web,1)] ;
%%%

%%% MSR Mail Data
msr_mail_folder = [ 'MS/Processed/mail/' ] ;

msr_mail_data = importdata([msr_mail_folder 'mail_full_MSR_30min.csv']) ;
msr_mail_data = split( msr_mail_data , ',' ) ;

msr_mail_count_read_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 2 )) ;
msr_mail_size_read_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 3 )) ;
msr_mail_sl_read_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 4 )) ;
msr_mail_burst_read_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 5 )) ;
msr_mail_cad_read_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 6 )) ;

msr_mail_count_write_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 7 )) ;
msr_mail_size_write_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 8 )) ;
msr_mail_sl_write_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 9 )) ;
msr_mail_burst_write_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 10 )) ;
msr_mail_cad_write_bin_30mnt = cellfun(@str2num , msr_mail_data( : , 11 )) ;

msr_mail_data = [msr_mail_count_read_bin_30mnt msr_mail_size_read_bin_30mnt msr_mail_burst_read_bin_30mnt msr_mail_cad_read_bin_30mnt ...
    msr_mail_count_write_bin_30mnt msr_mail_size_write_bin_30mnt msr_mail_burst_write_bin_30mnt msr_mail_cad_write_bin_30mnt] ;

msr_mail_data(isnan(msr_mail_data)) = 0 ;

[N_msr_mail , P_msr_home] = size(msr_mail_data) ;
msr_mail_data = [msr_mail_data 3*ones(N_msr_mail,1)] ;
%%%

%%% All MSR Data
msr_data = [msr_home_data ; msr_web_data ; msr_mail_data] ;

[N_msr , P_msr] = size( msr_data( : , 1 : end - 1) ) ;

i_shuffle_msr = randperm( N_msr , N_msr ) ;

msr_data = msr_data( i_shuffle_msr , :) ;
%%%

msr_data_original = msr_data ;
msr_home_data_original = msr_home_data ;
msr_web_data_original = msr_web_data ;
msr_mail_data_original = msr_mail_data ;

%% Data Summary

%%% home
fiu_home_count_read = fiu_home_data( : , 1 ) ;
fiu_home_size_read = fiu_home_data( : , 2 ) ;
% fiu_home_sl_read = fiu_home_data( : , 3 ) ;
fiu_home_burst_read = fiu_home_data( : , 3 ) ;
fiu_home_cad_read = fiu_home_data( : , 4 ) ;

fiu_home_count_write = fiu_home_data( : , 5 ) ;
fiu_home_size_write = fiu_home_data( : , 6 ) ;
% fiu_home_sl_write = fiu_home_data( : , 8 ) ;
fiu_home_burst_write = fiu_home_data( : , 7 ) ;
fiu_home_cad_write = fiu_home_data( : , 8 ) ;

msr_home_count_read = msr_home_data( : , 1 ) ;
msr_home_size_read = msr_home_data( : , 2 ) ;
% msr_home_sl_read = msr_home_data( : , 3 ) ;
msr_home_burst_read = msr_home_data( : , 3 ) ;
msr_home_cad_read = msr_home_data( : , 4 ) ;

msr_home_count_write = msr_home_data( : , 5 ) ;
msr_home_size_write = msr_home_data( : , 6 ) ;
% msr_home_sl_write = msr_home_data( : , 8 ) ;
msr_home_burst_write = msr_home_data( : , 7 ) ;
msr_home_cad_write = msr_home_data( : , 8 ) ;

fiu_home_count_read_log = fiu_home_data_log( : , 1 ) ;
fiu_home_size_read_log = fiu_home_data_log( : , 2 ) ;
% fiu_home_sl_read_log = fiu_home_data_log( : , 3 ) ) ;
fiu_home_burst_read_log = fiu_home_data_log( : , 3 ) ;
fiu_home_cad_read_log = fiu_home_data_log( : , 4 ) ;

fiu_home_count_write_log = fiu_home_data_log( : , 5 ) ;
fiu_home_size_write_log = fiu_home_data_log( : , 6 ) ;
% fiu_home_sl_write_log = fiu_home_data_log( : , 8 ) ) ;
fiu_home_burst_write_log = fiu_home_data_log( : , 7 ) ;
fiu_home_cad_write_log = fiu_home_data_log( : , 8 ) ;

msr_home_count_read_log = msr_home_data_log( : , 1 ) ;
msr_home_size_read_log = msr_home_data_log( : , 2 ) ;
% msr_home_sl_read_log = msr_home_data_log( : , 3 ) ) ;
msr_home_burst_read_log = msr_home_data_log( : , 3 ) ;
msr_home_cad_read_log = msr_home_data_log( : , 4 ) ;

msr_home_count_write_log = msr_home_data_log( : , 5 ) ;
msr_home_size_write_log = msr_home_data_log( : , 6 ) ;
% msr_home_sl_write_log = msr_home_data_log( : , 8 ) ) ;
msr_home_burst_write_log = msr_home_data_log( : , 7 ) ;
msr_home_cad_write_log = msr_home_data_log( : , 8 ) ;
%%%

%%% web
fiu_web_count_read = fiu_web_data( : , 1 ) ;
fiu_web_size_read = fiu_web_data( : , 2 ) ;
% fiu_web_sl_read = fiu_web_data( : , 3 ) ;
fiu_web_burst_read = fiu_web_data( : , 3 ) ;
fiu_web_cad_read = fiu_web_data( : , 4 ) ;

fiu_web_count_write = fiu_web_data( : , 5 ) ;
fiu_web_size_write = fiu_web_data( : , 6 ) ;
% fiu_web_sl_write = fiu_web_data( : , 8 ) ;
fiu_web_burst_write = fiu_web_data( : , 7 ) ;
fiu_web_cad_write = fiu_web_data( : , 8 ) ;

msr_web_count_read = msr_web_data( : , 1 ) ;
msr_web_size_read = msr_web_data( : , 2 ) ;
% msr_web_sl_read = msr_web_data( : , 3 ) ;
msr_web_burst_read = msr_web_data( : , 3 ) ;
msr_web_cad_read = msr_web_data( : , 4 ) ;

msr_web_count_write = msr_web_data( : , 5 ) ;
msr_web_size_write = msr_web_data( : , 6 ) ;
% msr_web_sl_write = msr_web_data( : , 8 ) ;
msr_web_burst_write = msr_web_data( : , 7 ) ;
msr_web_cad_write = msr_web_data( : , 8 ) ;

fiu_web_count_read_log = fiu_web_data_log( : , 1 ) ;
fiu_web_size_read_log = fiu_web_data_log( : , 2 ) ;
% fiu_web_sl_read_log = fiu_web_data_log( : , 3 ) ) ;
fiu_web_burst_read_log = fiu_web_data_log( : , 3 ) ;
fiu_web_cad_read_log = fiu_web_data_log( : , 4 ) ;

fiu_web_count_write_log = fiu_web_data_log( : , 5 ) ;
fiu_web_size_write_log = fiu_web_data_log( : , 6 ) ;
% fiu_web_sl_write_log = fiu_web_data_log( : , 8 ) ) ;
fiu_web_burst_write_log = fiu_web_data_log( : , 7 ) ;
fiu_web_cad_write_log = fiu_web_data_log( : , 8 ) ;

msr_web_count_read_log = msr_web_data_log( : , 1 ) ;
msr_web_size_read_log = msr_web_data_log( : , 2 ) ;
% msr_web_sl_read_log = msr_web_data_log( : , 3 ) ) ;
msr_web_burst_read_log = msr_web_data_log( : , 3 ) ;
msr_web_cad_read_log = msr_web_data_log( : , 4 ) ;

msr_web_count_write_log = msr_web_data_log( : , 5 ) ;
msr_web_size_write_log = msr_web_data_log( : , 6 ) ;
% msr_web_sl_write_log = msr_web_data_log( : , 8 ) ) ;
msr_web_burst_write_log = msr_web_data_log( : , 7 ) ;
msr_web_cad_write_log = msr_web_data_log( : , 8 ) ;
%%%

%%%
fiu_mail_count_read = fiu_mail_data( : , 1 ) ;
fiu_mail_size_read = fiu_mail_data( : , 2 ) ;
% fiu_mail_sl_read = fiu_mail_data( : , 3 ) ;
fiu_mail_burst_read = fiu_mail_data( : , 3 ) ;
fiu_mail_cad_read = fiu_mail_data( : , 4 ) ;

fiu_mail_count_write = fiu_mail_data( : , 5 ) ;
fiu_mail_size_write = fiu_mail_data( : , 6 ) ;
% fiu_mail_sl_write = fiu_mail_data( : , 8 ) ;
fiu_mail_burst_write = fiu_mail_data( : , 7 ) ;
fiu_mail_cad_write = fiu_mail_data( : , 8 ) ;

msr_mail_count_read = msr_mail_data( : , 1 ) ;
msr_mail_size_read = msr_mail_data( : , 2 ) ;
% msr_mail_sl_read = msr_mail_data( : , 3 ) ;
msr_mail_burst_read = msr_mail_data( : , 3 ) ;
msr_mail_cad_read = msr_mail_data( : , 4 ) ;

msr_mail_count_write = msr_mail_data( : , 5 ) ;
msr_mail_size_write = msr_mail_data( : , 6 ) ;
% msr_mail_sl_write = msr_mail_data( : , 8 ) ;
msr_mail_burst_write = msr_mail_data( : , 7 ) ;
msr_mail_cad_write = msr_mail_data( : , 8 ) ;

fiu_mail_count_read_log = fiu_mail_data_log( : , 1 ) ;
fiu_mail_size_read_log = fiu_mail_data_log( : , 2 ) ;
% fiu_mail_sl_read_log = fiu_mail_data_log( : , 3 ) ) ;
fiu_mail_burst_read_log = fiu_mail_data_log( : , 3 ) ;
fiu_mail_cad_read_log = fiu_mail_data_log( : , 4 ) ;

fiu_mail_count_write_log = fiu_mail_data_log( : , 5 ) ;
fiu_mail_size_write_log = fiu_mail_data_log( : , 6 ) ;
% fiu_mail_sl_write_log = fiu_mail_data_log( : , 8 ) ) ;
fiu_mail_burst_write_log = fiu_mail_data_log( : , 7 ) ;
fiu_mail_cad_write_log = fiu_mail_data_log( : , 8 ) ;

msr_mail_count_read_log = msr_mail_data_log( : , 1 ) ;
msr_mail_size_read_log = msr_mail_data_log( : , 2 ) ;
% msr_mail_sl_read_log = msr_mail_data_log( : , 3 ) ) ;
msr_mail_burst_read_log = msr_mail_data_log( : , 3 ) ;
msr_mail_cad_read_log = msr_mail_data_log( : , 4 ) ;

msr_mail_count_write_log = msr_mail_data_log( : , 5 ) ;
msr_mail_size_write_log = msr_mail_data_log( : , 6 ) ;
% msr_mail_sl_write_log = msr_mail_data_log( : , 8 ) ) ;
msr_mail_burst_write_log = msr_mail_data_log( : , 7 ) ;
msr_mail_cad_write_log = msr_mail_data_log( : , 8 ) ;
%%%

close all
figure(1)
subplot(4,3,1)
hold on
histogram(fiu_home_count_read , min(fiu_home_count_read) : (max(fiu_home_count_read)-min(fiu_home_count_read))/20 : max(fiu_home_count_read) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_count_read , min(msr_home_count_read) : (max(msr_home_count_read)-min(msr_home_count_read))/20 : max(msr_home_count_read) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,2)
hold on
histogram(fiu_web_count_read , min(fiu_web_count_read) : (max(fiu_web_count_read)-min(fiu_web_count_read))/20 : max(fiu_web_count_read) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_count_read , min(msr_web_count_read) : (max(msr_web_count_read)-min(msr_web_count_read))/20 : max(msr_web_count_read) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,3)
hold on
histogram(fiu_mail_count_read , min(fiu_mail_count_read) : (max(fiu_mail_count_read)-min(fiu_mail_count_read))/20 : max(fiu_mail_count_read) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_count_read , min(msr_mail_count_read) : (max(msr_mail_count_read)-min(msr_mail_count_read))/20 : max(msr_mail_count_read) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,4)
hold on
histogram(fiu_home_size_read , min(fiu_home_size_read) : (max(fiu_home_size_read)-min(fiu_home_size_read))/20 : max(fiu_home_size_read) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_size_read , min(msr_home_size_read) : (max(msr_home_size_read)-min(msr_home_size_read))/20 : max(msr_home_size_read) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,5)
hold on
histogram(fiu_web_size_read , min(fiu_web_size_read) : (max(fiu_web_size_read)-min(fiu_web_size_read))/20 : max(fiu_web_size_read) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_size_read , min(msr_web_size_read) : (max(msr_web_size_read)-min(msr_web_size_read))/20 : max(msr_web_size_read) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,6)
hold on
histogram(fiu_mail_size_read , min(fiu_mail_size_read) : (max(fiu_mail_size_read)-min(fiu_mail_size_read))/20 : max(fiu_mail_size_read) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_size_read , min(msr_mail_size_read) : (max(msr_mail_size_read)-min(msr_mail_size_read))/20 : max(msr_mail_size_read) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,7)
hold on
histogram(fiu_home_count_write , min(fiu_home_count_write) : (max(fiu_home_count_write)-min(fiu_home_count_write))/20 : max(fiu_home_count_write) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_count_write , min(msr_home_count_write) : (max(msr_home_count_write)-min(msr_home_count_write))/20 : max(msr_home_count_write) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,8)
hold on
histogram(fiu_web_count_write , min(fiu_web_count_write) : (max(fiu_web_count_write)-min(fiu_web_count_write))/20 : max(fiu_web_count_write) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_count_write , min(msr_web_count_write) : (max(msr_web_count_write)-min(msr_web_count_write))/20 : max(msr_web_count_write) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,9)
hold on
histogram(fiu_mail_count_write , min(fiu_mail_count_write) : (max(fiu_mail_count_write)-min(fiu_mail_count_write))/20 : max(fiu_mail_count_write) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_count_write , min(msr_mail_count_write) : (max(msr_mail_count_write)-min(msr_mail_count_write))/20 : max(msr_mail_count_write) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,10)
hold on
histogram(fiu_home_size_write , min(fiu_home_size_write) : (max(fiu_home_size_write)-min(fiu_home_size_write))/20 : max(fiu_home_size_write) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_size_write , min(msr_home_size_write) : (max(msr_home_size_write)-min(msr_home_size_write))/20 : max(msr_home_size_write) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,11)
hold on
histogram(fiu_web_size_write , min(fiu_web_size_write) : (max(fiu_web_size_write)-min(fiu_web_size_write))/20 : max(fiu_web_size_write) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_size_write , min(msr_web_size_write) : (max(msr_web_size_write)-min(msr_web_size_write))/20 : max(msr_web_size_write) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

subplot(4,3,12)
hold on
histogram(fiu_mail_size_write , min(fiu_mail_size_write) : (max(fiu_mail_size_write)-min(fiu_mail_size_write))/20 : max(fiu_mail_size_write) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_size_write , min(msr_mail_size_write) : (max(msr_mail_size_write)-min(msr_mail_size_write))/20 : max(msr_mail_size_write) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
hold off

figure(2)
subplot(8,3,1)
% count_read
hold on
histogram(fiu_home_count_read_log , min(fiu_home_count_read_log) : (max(fiu_home_count_read_log)-min(fiu_home_count_read_log))/20 : max(fiu_home_count_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_count_read_log , min(msr_home_count_read_log) : (max(msr_home_count_read_log)-min(msr_home_count_read_log))/20 : max(msr_home_count_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,2)
hold on
histogram(fiu_web_count_read_log , min(fiu_web_count_read_log) : (max(fiu_web_count_read_log)-min(fiu_web_count_read_log))/20 : max(fiu_web_count_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_count_read_log , min(msr_web_count_read_log) : (max(msr_web_count_read_log)-min(msr_web_count_read_log))/20 : max(msr_web_count_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,3)
hold on
histogram(fiu_mail_count_read_log , min(fiu_mail_count_read_log) : (max(fiu_mail_count_read_log)-min(fiu_mail_count_read_log))/20 : max(fiu_mail_count_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_count_read_log , min(msr_mail_count_read_log) : (max(msr_mail_count_read_log)-min(msr_mail_count_read_log))/20 : max(msr_mail_count_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

% size_read
subplot(8,3,4)
hold on
histogram(fiu_home_size_read_log , min(fiu_home_size_read_log) : (max(fiu_home_size_read_log)-min(fiu_home_size_read_log))/20 : max(fiu_home_size_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_size_read_log , min(msr_home_size_read_log) : (max(msr_home_size_read_log)-min(msr_home_size_read_log))/20 : max(msr_home_size_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,5)
hold on
histogram(fiu_web_size_read_log , min(fiu_web_size_read_log) : (max(fiu_web_size_read_log)-min(fiu_web_size_read_log))/20 : max(fiu_web_size_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_size_read_log , min(msr_web_size_read_log) : (max(msr_web_size_read_log)-min(msr_web_size_read_log))/20 : max(msr_web_size_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,6)
hold on
histogram(fiu_mail_size_read_log , min(fiu_mail_size_read_log) : (max(fiu_mail_size_read_log)-min(fiu_mail_size_read_log))/20 : max(fiu_mail_size_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_size_read_log , min(msr_mail_size_read_log) : (max(msr_mail_size_read_log)-min(msr_mail_size_read_log))/20 : max(msr_mail_size_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

% burst_read
subplot(8,3,7)
hold on
histogram(fiu_home_burst_read_log , min(fiu_home_burst_read_log) : (max(fiu_home_burst_read_log)-min(fiu_home_burst_read_log))/20 : max(fiu_home_burst_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_burst_read_log , min(msr_home_burst_read_log) : (max(msr_home_burst_read_log)-min(msr_home_burst_read_log))/20 : max(msr_home_burst_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,8)
hold on
histogram(fiu_web_burst_read_log , min(fiu_web_burst_read_log) : (max(fiu_web_burst_read_log)-min(fiu_web_burst_read_log))/20 : max(fiu_web_burst_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_burst_read_log , min(msr_web_burst_read_log) : (max(msr_web_burst_read_log)-min(msr_web_burst_read_log))/20 : max(msr_web_burst_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,9)
hold on
histogram(fiu_mail_burst_read_log , min(fiu_mail_burst_read_log) : (max(fiu_mail_burst_read_log)-min(fiu_mail_burst_read_log))/20 : max(fiu_mail_burst_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_burst_read_log , min(msr_mail_burst_read_log) : (max(msr_mail_burst_read_log)-min(msr_mail_burst_read_log))/20 : max(msr_mail_burst_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

% cad_read
subplot(8,3,10)
hold on
histogram(fiu_home_cad_read_log , min(fiu_home_cad_read_log) : (max(fiu_home_cad_read_log)-min(fiu_home_cad_read_log))/20 : max(fiu_home_cad_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_cad_read_log , min(msr_home_cad_read_log) : (max(msr_home_cad_read_log)-min(msr_home_cad_read_log))/20 : max(msr_home_cad_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,11)
hold on
histogram(fiu_web_cad_read_log , min(fiu_web_cad_read_log) : (max(fiu_web_cad_read_log)-min(fiu_web_cad_read_log))/20 : max(fiu_web_cad_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_cad_read_log , min(msr_web_cad_read_log) : (max(msr_web_cad_read_log)-min(msr_web_cad_read_log))/20 : max(msr_web_cad_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,12)
hold on
histogram(fiu_mail_cad_read_log , min(fiu_mail_cad_read_log) : (max(fiu_mail_cad_read_log)-min(fiu_mail_cad_read_log))/20 : max(fiu_mail_cad_read_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_cad_read_log , min(msr_mail_cad_read_log) : (max(msr_mail_cad_read_log)-min(msr_mail_cad_read_log))/20 : max(msr_mail_cad_read_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

subplot(8,3,13)
% count_write
hold on
histogram(fiu_home_count_write_log , min(fiu_home_count_write_log) : (max(fiu_home_count_write_log)-min(fiu_home_count_write_log))/20 : max(fiu_home_count_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_count_write_log , min(msr_home_count_write_log) : (max(msr_home_count_write_log)-min(msr_home_count_write_log))/20 : max(msr_home_count_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,14)
hold on
histogram(fiu_web_count_write_log , min(fiu_web_count_write_log) : (max(fiu_web_count_write_log)-min(fiu_web_count_write_log))/20 : max(fiu_web_count_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_count_write_log , min(msr_web_count_write_log) : (max(msr_web_count_write_log)-min(msr_web_count_write_log))/20 : max(msr_web_count_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,15)
hold on
histogram(fiu_mail_count_write_log , min(fiu_mail_count_write_log) : (max(fiu_mail_count_write_log)-min(fiu_mail_count_write_log))/20 : max(fiu_mail_count_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_count_write_log , min(msr_mail_count_write_log) : (max(msr_mail_count_write_log)-min(msr_mail_count_write_log))/20 : max(msr_mail_count_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

subplot(8,3,16)
% size_write
hold on
histogram(fiu_home_size_write_log , min(fiu_home_size_write_log) : (max(fiu_home_size_write_log)-min(fiu_home_size_write_log))/20 : max(fiu_home_size_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_size_write_log , min(msr_home_size_write_log) : (max(msr_home_size_write_log)-min(msr_home_size_write_log))/20 : max(msr_home_size_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,17)
hold on
histogram(fiu_web_size_write_log , min(fiu_web_size_write_log) : (max(fiu_web_size_write_log)-min(fiu_web_size_write_log))/20 : max(fiu_web_size_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_size_write_log , min(msr_web_size_write_log) : (max(msr_web_size_write_log)-min(msr_web_size_write_log))/20 : max(msr_web_size_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,18)
hold on
histogram(fiu_mail_size_write_log , min(fiu_mail_size_write_log) : (max(fiu_mail_size_write_log)-min(fiu_mail_size_write_log))/20 : max(fiu_mail_size_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_size_write_log , min(msr_mail_size_write_log) : (max(msr_mail_size_write_log)-min(msr_mail_size_write_log))/20 : max(msr_mail_size_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

subplot(8,3,19)
% burst_write
hold on
histogram(fiu_home_burst_write_log , min(fiu_home_burst_write_log) : (max(fiu_home_burst_write_log)-min(fiu_home_burst_write_log))/20 : max(fiu_home_burst_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_burst_write_log , min(msr_home_burst_write_log) : (max(msr_home_burst_write_log)-min(msr_home_burst_write_log))/20 : max(msr_home_burst_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,20)
hold on
histogram(fiu_web_burst_write_log , min(fiu_web_burst_write_log) : (max(fiu_web_burst_write_log)-min(fiu_web_burst_write_log))/20 : max(fiu_web_burst_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_burst_write_log , min(msr_web_burst_write_log) : (max(msr_web_burst_write_log)-min(msr_web_burst_write_log))/20 : max(msr_web_burst_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,21)
hold on
histogram(fiu_mail_burst_write_log , min(fiu_mail_burst_write_log) : (max(fiu_mail_burst_write_log)-min(fiu_mail_burst_write_log))/20 : max(fiu_mail_burst_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_burst_write_log , min(msr_mail_burst_write_log) : (max(msr_mail_burst_write_log)-min(msr_mail_burst_write_log))/20 : max(msr_mail_burst_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

subplot(8,3,22)
% cad_write
hold on
histogram(fiu_home_cad_write_log , min(fiu_home_cad_write_log) : (max(fiu_home_cad_write_log)-min(fiu_home_cad_write_log))/20 : max(fiu_home_cad_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_home_cad_write_log , min(msr_home_cad_write_log) : (max(msr_home_cad_write_log)-min(msr_home_cad_write_log))/20 : max(msr_home_cad_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,23)
hold on
histogram(fiu_web_cad_write_log , min(fiu_web_cad_write_log) : (max(fiu_web_cad_write_log)-min(fiu_web_cad_write_log))/20 : max(fiu_web_cad_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_web_cad_write_log , min(msr_web_cad_write_log) : (max(msr_web_cad_write_log)-min(msr_web_cad_write_log))/20 : max(msr_web_cad_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off

subplot(8,3,24)
hold on
histogram(fiu_mail_cad_write_log , min(fiu_mail_cad_write_log) : (max(fiu_mail_cad_write_log)-min(fiu_mail_cad_write_log))/20 : max(fiu_mail_cad_write_log) , 'facecolor' , [1 0 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
histogram(msr_mail_cad_write_log , min(msr_mail_cad_write_log) : (max(msr_mail_cad_write_log)-min(msr_mail_cad_write_log))/20 : max(msr_mail_cad_write_log) , 'facecolor' , [0 1 0] , 'edgecolor' , 'none' , 'Normalization','probability') ; % ...
set(gca,'FontSize',20) ; hold off
%

%% Training and Test data

% testing and training indices
i_fiu = (1 : N_fiu)' ;

N_fiu_train = floor( N_fiu * 0.8 ) ;
N_fiu_test = N_fiu - N_fiu_train ;

i_fiu_train = randperm( N_fiu , N_fiu_train ) ;

i_fiu_test = i_fiu ;
i_fiu_test(i_fiu_train) = [ ] ;
%

% training and test data (non-logged)
fiu_train = fiu_data( i_fiu_train , : ) ;
fiu_feature_train = fiu_train( : , 1 : end - 1) ;
fiu_label_train = fiu_train( : , end) ;

fiu_test = fiu_data( i_fiu_test , : ) ;
fiu_feature_test = fiu_test( : , 1 : end - 1) ;
fiu_label_test = fiu_test( : , end) ;
%

% training and test data (logged)
fiu_feature_train_log = log(fiu_feature_train + 1) ;
fiu_feature_test_log = log(fiu_feature_test + 1) ;
%

msr_feature_test = msr_data( : , 1 : end - 1)  ;
z_msr_feature_test = zscore(msr_feature_test) ;

msr_label_test = msr_data( : , end)  ;
N_msr_test = size(msr_label_test,1) ;

z_msr_feature_test = zscore(msr_feature_test) ;
msr_feature_test_log = log(msr_feature_test + 1) ;
z_msr_feature_test_log = zscore(msr_feature_test_log) ; 

%% Correlation and mutual information

%%% non-logged
fiu_feature_label_abs_corr_train = ...
    abs(((fiu_feature_train -mean(fiu_feature_train ))' * (fiu_label_train-mean(fiu_label_train))) ./ ...
    sqrt(diag((fiu_feature_train -mean(fiu_feature_train ))' * (fiu_feature_train -mean(fiu_feature_train ))) ...
    * (fiu_label_train-mean(fiu_label_train))' * (fiu_label_train-mean(fiu_label_train)))) ;

corr_thresh = 0.8 ;

fiu_feature_corr = (fiu_feature_train - mean(fiu_feature_train))' * (fiu_feature_train-mean(fiu_feature_train)) ...
    ./ sqrt( (diag((fiu_feature_train -mean(fiu_feature_train ))' * (fiu_feature_train -mean(fiu_feature_train )))*diag((fiu_feature_train -mean(fiu_feature_train ))' * (fiu_feature_train -mean(fiu_feature_train )))'  ) ) ;

[i_row , i_col] = find(abs(fiu_feature_corr) > corr_thresh ...
    & abs(fiu_feature_corr) < 1) ;

i_corr = [i_row i_col] ;

i_corr(i_corr(:,2) >= i_corr(:,1),:) = [ ] ;

fiu_feature_corr_high = zeros( size(i_corr , 1) , 1) ;

for j_corr = 1 : size(i_corr , 1)
    
    fiu_feature_corr_high(j_corr) = fiu_feature_corr( i_corr(j_corr,1) , i_corr(j_corr,2) ) ;
    
end

[ ~ , i_sort] = sort(fiu_feature_corr_high , 'descend') ;

fiu_feature_corr_high_sort = fiu_feature_corr_high(i_sort ) ;
fiu_feature_label_abs_corr_train_sort = fiu_feature_label_abs_corr_train(i_sort) ;

i_corr_sort = i_corr(i_sort , :) ;

fiu_feature_label_abs_corr_variable = fiu_feature_label_abs_corr_train(i_corr_sort) ;

variable(i_corr_sort)
variable(i_sort)
%%%

%%% logged
fiu_feature_label_abs_corr_train_log = ...
    abs(((fiu_feature_train_log -mean(fiu_feature_train_log ))' * (fiu_label_train-mean(fiu_label_train))) ./ ...
    sqrt(diag((fiu_feature_train_log -mean(fiu_feature_train_log ))' * (fiu_feature_train_log -mean(fiu_feature_train_log ))) ...
    * (fiu_label_train-mean(fiu_label_train))' * (fiu_label_train-mean(fiu_label_train)))) ;

corr_thresh = 0.8 ;

fiu_feature_corr_log = (fiu_feature_train_log - mean(fiu_feature_train_log))' * (fiu_feature_train_log-mean(fiu_feature_train_log)) ...
    ./ sqrt( (diag((fiu_feature_train_log -mean(fiu_feature_train_log ))' * (fiu_feature_train_log -mean(fiu_feature_train_log )))*diag((fiu_feature_train_log -mean(fiu_feature_train_log ))' * (fiu_feature_train_log -mean(fiu_feature_train_log )))'  ) ) ;

[i_row , i_col] = find(abs(fiu_feature_corr_log) > corr_thresh ...
    & abs(fiu_feature_corr_log) < 1) ;

i_corr_log = [i_row i_col] ;

i_corr_log(i_corr_log(:,2) >= i_corr_log(:,1),:) = [ ] ;

fiu_feature_corr_log_high_log = zeros( size(i_corr_log , 1) , 1) ;

for j_corr = 1 : size(i_corr_log , 1)
    
    fiu_feature_corr_log_high_log(j_corr) = fiu_feature_corr_log( i_corr_log(j_corr,1) , i_corr_log(j_corr,2) ) ;
    
end

[ ~ , i_sort_log] = sort(fiu_feature_corr_log_high_log , 'descend') ;

fiu_feature_corr_log_high_log_sort = fiu_feature_corr_log_high_log(i_sort_log ) ;
fiu_feature_label_abs_corr_train_log_sort = fiu_feature_label_abs_corr_train_log(i_sort_log) ;

i_corr_log_sort = i_corr_log(i_sort_log , :) ;

fiu_feature_label_abs_corr_variable = fiu_feature_label_abs_corr_train_log(i_corr_log_sort) ;

variable(i_corr_log_sort)
variable(i_sort_log)
%%%

%% Classification Tree (FIU data)

fiu_model_tree = ...
    fitctree( fiu_feature_train , fiu_label_train , ...
    'OptimizeHyperparameters' , {'MaxNumSplits','MinLeafSize'} , ...
    'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

fiu_model_tree_log = ...
    fitctree( fiu_feature_train_log , fiu_label_train , ...
    'OptimizeHyperparameters' , {'MaxNumSplits' ,'MinLeafSize' } , ...
    'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

%%

%%% non-logged
[fiu_predict_test_tree , fiu_score_test_tree ] = predict( fiu_model_tree , fiu_feature_test ) ;

score_home_tree = fiu_score_test_tree(:,1) - max(fiu_score_test_tree(:,2) , fiu_score_test_tree(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_tree] = perfcurve(fiu_label_test , score_home_tree , '1') ;

score_web_tree = fiu_score_test_tree(:,2) - max(fiu_score_test_tree(:,1) , fiu_score_test_tree(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_tree] = perfcurve(fiu_label_test , score_web_tree , '2') ;

score_mail_tree = fiu_score_test_tree(:,3) - max(fiu_score_test_tree(:,1) , fiu_score_test_tree(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_tree] = perfcurve(fiu_label_test , score_mail_tree , '3') ;

fiu_accuracy_rate_tree = sum(( fiu_predict_test_tree ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_tree = zeros(3) ;
for i_pred = 1 : 3
    for i_test = 1 : 3
        fiu_confusion_tree(i_pred,i_test) = sum( (fiu_predict_test_tree == i_pred) & (fiu_label_test == i_test) ) ;
    end
end

fiu_tp_tree = diag(fiu_confusion_tree)' ;
fiu_fp_tree = diag(fiu_confusion_tree * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_tree = diag(fiu_confusion_tree' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_tree = fiu_tp_tree ./ (fiu_tp_tree + fiu_fp_tree) ;
fiu_recall_tree = fiu_tp_tree ./ (fiu_tp_tree + fiu_fn_tree) ;
%%%

%%% logged
[fiu_predict_test_tree_log , fiu_score_test_tree_log ] = predict( fiu_model_tree_log , fiu_feature_test_log ) ;

score_home_tree_log = fiu_score_test_tree_log(:,1) - max(fiu_score_test_tree_log(:,2) , fiu_score_test_tree_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_tree_log] = perfcurve(fiu_label_test , score_home_tree_log , '1') ;

score_web_tree_log = fiu_score_test_tree_log(:,2) - max(fiu_score_test_tree_log(:,1) , fiu_score_test_tree_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_tree_log] = perfcurve(fiu_label_test , score_web_tree_log , '2') ;

score_mail_tree_log = fiu_score_test_tree_log(:,3) - max(fiu_score_test_tree_log(:,1) , fiu_score_test_tree_log(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_tree_log] = perfcurve(fiu_label_test , score_mail_tree_log , '3') ;

fiu_accuracy_rate_tree_log = sum(( fiu_predict_test_tree_log ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_tree_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        fiu_confusion_tree_log(i_pred,i_test_log) = sum( (fiu_predict_test_tree_log == i_pred) & (fiu_label_test == i_test_log) ) ;
    end
end

fiu_tp_tree_log = diag(fiu_confusion_tree_log)' ;
fiu_fp_tree_log = diag(fiu_confusion_tree_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_tree_log = diag(fiu_confusion_tree_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_tree_log = fiu_tp_tree_log ./ (fiu_tp_tree_log + fiu_fp_tree_log) ;
fiu_recall_tree_log = fiu_tp_tree_log ./ (fiu_tp_tree_log + fiu_fn_tree_log) ;
%%%

%% Naive Bayes Classification (FIU Data)

z_fiu_feature_train = zscore(fiu_feature_train) ;
z_fiu_feature_test = zscore(fiu_feature_test) ;

z_fiu_feature_train_log = zscore(fiu_feature_train_log) ;
z_fiu_feature_test_log = zscore(fiu_feature_test_log) ;

z_msr_feature_test = zscore(msr_feature_test) ;

fiu_model_nb = ...
    fitcnb( z_fiu_feature_train , fiu_label_train , ...
    'DistributionNames' , 'Kernel' , ...
    'OptimizeHyperparameters' , {'Width'} , ...
    'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

fiu_model_nb_log = ...
    fitcnb( z_fiu_feature_train_log , fiu_label_train , ...
    'DistributionNames' , 'Kernel' , ...
    'OptimizeHyperparameters' , {'Width'} , ...
    'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

%%

%%% non-logged
[fiu_predict_test_nb , fiu_score_test_nb ] = predict( fiu_model_nb , z_fiu_feature_test ) ;

score_home_nb = fiu_score_test_nb(:,1) - max(fiu_score_test_nb(:,2) , fiu_score_test_nb(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_nb] = perfcurve(fiu_label_test , score_home_nb , '1') ;

score_web_nb = fiu_score_test_nb(:,2) - max(fiu_score_test_nb(:,1) , fiu_score_test_nb(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_nb] = perfcurve(fiu_label_test , score_web_nb , '2') ;

score_mail_nb = fiu_score_test_nb(:,3) - max(fiu_score_test_nb(:,1) , fiu_score_test_nb(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_nb] = perfcurve(fiu_label_test , score_mail_nb , '3') ;

fiu_accuracy_rate_nb = sum(( fiu_predict_test_nb ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_nb = zeros(3) ;
for i_pred = 1 : 3
    for i_test = 1 : 3
        fiu_confusion_nb(i_pred,i_test) = sum( (fiu_predict_test_nb == i_pred) & (fiu_label_test == i_test) ) ;
    end
end

fiu_tp_nb = diag(fiu_confusion_nb)' ;
fiu_fp_nb = diag(fiu_confusion_nb * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_nb = diag(fiu_confusion_nb' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_nb = fiu_tp_nb ./ (fiu_tp_nb + fiu_fp_nb) ;
fiu_recall_nb = fiu_tp_nb ./ (fiu_tp_nb + fiu_fn_nb) ;
%%%

%%% logged
[fiu_predict_test_nb_log , fiu_score_test_nb_log ] = predict( fiu_model_nb_log , z_fiu_feature_test_log ) ;

score_home_nb_log = fiu_score_test_nb_log(:,1) - max(fiu_score_test_nb_log(:,2) , fiu_score_test_nb_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_nb_log] = perfcurve(fiu_label_test , score_home_nb_log , '1') ;

score_web_nb_log = fiu_score_test_nb_log(:,2) - max(fiu_score_test_nb_log(:,1) , fiu_score_test_nb_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_nb_log] = perfcurve(fiu_label_test , score_web_nb_log , '2') ;

score_mail_nb_log = fiu_score_test_nb_log(:,3) - max(fiu_score_test_nb_log(:,1) , fiu_score_test_nb_log(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_nb_log] = perfcurve(fiu_label_test , score_mail_nb_log , '3') ;

fiu_accuracy_rate_nb_log = sum(( fiu_predict_test_nb_log ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_nb_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        fiu_confusion_nb_log(i_pred,i_test_log) = sum( (fiu_predict_test_nb_log == i_pred) & (fiu_label_test == i_test_log) ) ;
    end
end

fiu_tp_nb_log = diag(fiu_confusion_nb_log)' ;
fiu_fp_nb_log = diag(fiu_confusion_nb_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_nb_log = diag(fiu_confusion_nb_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_nb_log = fiu_tp_nb_log ./ (fiu_tp_nb_log + fiu_fp_nb_log) ;
fiu_recall_nb_log = fiu_tp_nb_log ./ (fiu_tp_nb_log + fiu_fn_nb_log) ;
%%%

%% Multinomial Logistic Regression (FIU Data)

% %%% non-logged
% [fiu_model_lr , fiu_dev_lr , fiu_stats_lr] =  mnrfit( fiu_feature_train , categorical(fiu_label_train) ) ;
%
% fiu_UL_lr = fiu_stats_lr.beta + 1.96 * fiu_stats_lr.se ;
% fiu_LL_lr = fiu_stats_lr.beta - 1.96 * fiu_stats_lr.se ;
% %%%

%%% logged
[fiu_model_lr_log , fiu_dev_lr_log , fiu_stats_lr_log] =  mnrfit( fiu_feature_train_log , categorical(fiu_label_train) ) ;

fiu_UL_lr_log = fiu_stats_lr_log.beta + 1.96 * fiu_stats_lr_log.se ;
fiu_LL_lr_log = fiu_stats_lr_log.beta - 1.96 * fiu_stats_lr_log.se ;
%%%

%%

% %%% non-logged
% fiu_prob_test_lr = mnrval( fiu_model_lr , fiu_feature_test) ;
% fiu_predict_test_lr = (fiu_prob_test_lr == max(fiu_prob_test_lr,[],2)) * [1 2 3]' ;
% 
% fiu_score_test_lr = fiu_prob_test_lr ;
% 
% score_home_lr = fiu_score_test_lr(:,1) - max(fiu_score_test_lr(:,2) , fiu_score_test_lr(:,3)) ;
% [~ , ~ , ~ , fiu_auc_home_lr] = perfcurve(fiu_label_test , score_home_lr , '1') ;
% 
% score_web_lr = fiu_score_test_lr(:,2) - max(fiu_score_test_lr(:,1) , fiu_score_test_lr(:,3)) ;
% [~ , ~ , ~ , fiu_auc_web_lr] = perfcurve(fiu_label_test , score_web_lr , '2') ;
% 
% score_mail_lr = fiu_score_test_lr(:,3) - max(fiu_score_test_lr(:,1) , fiu_score_test_lr(:,2)) ;
% [~ , ~ , ~ , fiu_auc_mail_lr] = perfcurve(fiu_label_test , score_mail_lr , '3') ;
% 
% fiu_accuracy_rate_lr = sum(( fiu_predict_test_lr ==  fiu_label_test)) / N_fiu_test ;
% 
% fiu_confusion_lr = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         fiu_confusion_lr(i_pred,i_test) = sum( (fiu_predict_test_lr == i_pred) & (fiu_label_test == i_test) ) ;
%     end
% end
% 
% fiu_tp_lr = diag(fiu_confusion_lr)' ;
% fiu_fp_lr = diag(fiu_confusion_lr * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% fiu_fn_lr = diag(fiu_confusion_lr' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
% 
% fiu_precision_lr = fiu_tp_lr ./ (fiu_tp_lr + fiu_fp_lr) ;
% fiu_recall_lr = fiu_tp_lr ./ (fiu_tp_lr + fiu_fn_lr) ;
% %%%

%%% logged
fiu_prob_test_lr_log = mnrval( fiu_model_lr_log , fiu_feature_test_log) ;
fiu_predict_test_lr_log = (fiu_prob_test_lr_log == max(fiu_prob_test_lr_log,[],2)) * [1 2 3]' ;

fiu_score_test_lr_log = fiu_prob_test_lr_log ;

score_home_lr_log = fiu_score_test_lr_log(:,1) - max(fiu_score_test_lr_log(:,2) , fiu_score_test_lr_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_lr_log] = perfcurve(fiu_label_test , score_home_lr_log , '1') ;

score_web_lr_log = fiu_score_test_lr_log(:,2) - max(fiu_score_test_lr_log(:,1) , fiu_score_test_lr_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_lr_log] = perfcurve(fiu_label_test , score_web_lr_log , '2') ;

score_mail_lr_log = fiu_score_test_lr_log(:,3) - max(fiu_score_test_lr_log(:,1) , fiu_score_test_lr_log(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_lr_log] = perfcurve(fiu_label_test , score_mail_lr_log , '3') ;

fiu_accuracy_rate_lr_log = sum(( fiu_predict_test_lr_log ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_lr_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        fiu_confusion_lr_log(i_pred,i_test_log) = sum( (fiu_predict_test_lr_log == i_pred) & (fiu_label_test == i_test_log) ) ;
    end
end

fiu_tp_lr_log = diag(fiu_confusion_lr_log)' ;
fiu_fp_lr_log = diag(fiu_confusion_lr_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_lr_log = diag(fiu_confusion_lr_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_lr_log = fiu_tp_lr_log ./ (fiu_tp_lr_log + fiu_fp_lr_log) ;
fiu_recall_lr_log = fiu_tp_lr_log ./ (fiu_tp_lr_log + fiu_fn_lr_log) ;
%%%

%% Classification Tree (MSR data)

%%% non-logged
[msr_predict_test_tree , msr_score_test_tree ] = predict( fiu_model_tree , msr_feature_test ) ;

score_home_tree = msr_score_test_tree(:,1) - max(msr_score_test_tree(:,2) , msr_score_test_tree(:,3)) ;
[~ , ~ , ~ , msr_auc_home_tree] = perfcurve(msr_label_test , score_home_tree , '1') ;

score_web_tree = msr_score_test_tree(:,2) - max(msr_score_test_tree(:,1) , msr_score_test_tree(:,3)) ;
[~ , ~ , ~ , msr_auc_web_tree] = perfcurve(msr_label_test , score_web_tree , '2') ;

score_mail_tree = msr_score_test_tree(:,3) - max(msr_score_test_tree(:,1) , msr_score_test_tree(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_tree] = perfcurve(msr_label_test , score_mail_tree , '3') ;

msr_accuracy_rate_tree = sum(( msr_predict_test_tree ==  msr_label_test)) / N_msr_test ;

msr_confusion_tree = zeros(3) ;
for i_pred = 1 : 3
    for i_test = 1 : 3
        msr_confusion_tree(i_pred,i_test) = sum( (msr_predict_test_tree == i_pred) & (msr_label_test == i_test) ) ;
    end
end

msr_tp_tree = diag(msr_confusion_tree)' ;
msr_fp_tree = diag(msr_confusion_tree * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_tree = diag(msr_confusion_tree' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_tree = msr_tp_tree ./ (msr_tp_tree + msr_fp_tree) ;
msr_recall_tree = msr_tp_tree ./ (msr_tp_tree + msr_fn_tree) ;
%%%

%%% logged
[msr_predict_test_tree_log , msr_score_test_tree_log ] = predict( fiu_model_tree_log , msr_feature_test_log ) ;

score_home_tree_log = msr_score_test_tree_log(:,1) - max(msr_score_test_tree_log(:,2) , msr_score_test_tree_log(:,3)) ;
[~ , ~ , ~ , msr_auc_home_tree_log] = perfcurve(msr_label_test , score_home_tree_log , '1') ;

score_web_tree_log = msr_score_test_tree_log(:,2) - max(msr_score_test_tree_log(:,1) , msr_score_test_tree_log(:,3)) ;
[~ , ~ , ~ , msr_auc_web_tree_log] = perfcurve(msr_label_test , score_web_tree_log , '2') ;

score_mail_tree_log = msr_score_test_tree_log(:,3) - max(msr_score_test_tree_log(:,1) , msr_score_test_tree_log(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_tree_log] = perfcurve(msr_label_test , score_mail_tree_log , '3') ;

msr_accuracy_rate_tree_log = sum(( msr_predict_test_tree_log ==  msr_label_test)) / N_msr_test ;

msr_confusion_tree_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        msr_confusion_tree_log(i_pred,i_test_log) = sum( (msr_predict_test_tree_log == i_pred) & (msr_label_test == i_test_log) ) ;
    end
end

msr_tp_tree_log = diag(msr_confusion_tree_log)' ;
msr_fp_tree_log = diag(msr_confusion_tree_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_tree_log = diag(msr_confusion_tree_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_tree_log = msr_tp_tree_log ./ (msr_tp_tree_log + msr_fp_tree_log) ;
msr_recall_tree_log = msr_tp_tree_log ./ (msr_tp_tree_log + msr_fn_tree_log) ;
%%%

%% Naive Bayes Classification (MSR Data)

%%% non-logged
[msr_predict_test_nb , msr_score_test_nb ] = predict( fiu_model_nb , z_msr_feature_test_log ) ;

score_home_nb = msr_score_test_nb(:,1) - max(msr_score_test_nb(:,2) , msr_score_test_nb(:,3)) ;
[~ , ~ , ~ , msr_auc_home_nb] = perfcurve(msr_label_test , score_home_nb , '1') ;

score_web_nb = msr_score_test_nb(:,2) - max(msr_score_test_nb(:,1) , msr_score_test_nb(:,3)) ;
[~ , ~ , ~ , msr_auc_web_nb] = perfcurve(msr_label_test , score_web_nb , '2') ;

score_mail_nb = msr_score_test_nb(:,3) - max(msr_score_test_nb(:,1) , msr_score_test_nb(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_nb] = perfcurve(msr_label_test , score_mail_nb , '3') ;

msr_accuracy_rate_nb = sum(( msr_predict_test_nb ==  msr_label_test)) / N_msr_test ;

msr_confusion_nb = zeros(3) ;
for i_pred = 1 : 3
    for i_test = 1 : 3
        msr_confusion_nb(i_pred,i_test) = sum( (msr_predict_test_nb == i_pred) & (msr_label_test == i_test) ) ;
    end
end

msr_tp_nb = diag(msr_confusion_nb)' ;
msr_fp_nb = diag(msr_confusion_nb * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_nb = diag(msr_confusion_nb' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_nb = msr_tp_nb ./ (msr_tp_nb + msr_fp_nb) ;
msr_recall_nb = msr_tp_nb ./ (msr_tp_nb + msr_fn_nb) ;
%%%

%%% logged
[msr_predict_test_nb_log , msr_score_test_nb_log ] = predict( fiu_model_nb_log , z_msr_feature_test_log ) ;

score_home_nb_log = msr_score_test_nb_log(:,1) - max(msr_score_test_nb_log(:,2) , msr_score_test_nb_log(:,3)) ;
[~ , ~ , ~ , msr_auc_home_nb_log] = perfcurve(msr_label_test , score_home_nb_log , '1') ;

score_web_nb_log = msr_score_test_nb_log(:,2) - max(msr_score_test_nb_log(:,1) , msr_score_test_nb_log(:,3)) ;
[~ , ~ , ~ , msr_auc_web_nb_log] = perfcurve(msr_label_test , score_web_nb_log , '2') ;

score_mail_nb_log = msr_score_test_nb_log(:,3) - max(msr_score_test_nb_log(:,1) , msr_score_test_nb_log(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_nb_log] = perfcurve(msr_label_test , score_mail_nb_log , '3') ;

msr_accuracy_rate_nb_log = sum(( msr_predict_test_nb_log ==  msr_label_test)) / N_msr_test ;

msr_confusion_nb_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        msr_confusion_nb_log(i_pred,i_test_log) = sum( (msr_predict_test_nb_log == i_pred) & (msr_label_test == i_test_log) ) ;
    end
end

msr_tp_nb_log = diag(msr_confusion_nb_log)' ;
msr_fp_nb_log = diag(msr_confusion_nb_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_nb_log = diag(msr_confusion_nb_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_nb_log = msr_tp_nb_log ./ (msr_tp_nb_log + msr_fp_nb_log) ;
msr_recall_nb_log = msr_tp_nb_log ./ (msr_tp_nb_log + msr_fn_nb_log) ;
%%%

%% Multinomial Logistic Regression (MSR Data)

% %%% non-logged
% msr_prob_test_lr = mnrval( fiu_model_lr , msr_feature_test) ;
% msr_predict_test_lr = (msr_prob_test_lr == max(msr_prob_test_lr,[],2)) * [1 2 3]' ;
% 
% msr_score_test_lr = msr_prob_test_lr ;
% 
% score_home_lr = msr_score_test_lr(:,1) - max(msr_score_test_lr(:,2) , msr_score_test_lr(:,3)) ;
% [~ , ~ , ~ , msr_auc_home_lr] = perfcurve(msr_label_test , score_home_lr , '1') ;
% 
% score_web_lr = msr_score_test_lr(:,2) - max(msr_score_test_lr(:,1) , msr_score_test_lr(:,3)) ;
% [~ , ~ , ~ , msr_auc_web_lr] = perfcurve(msr_label_test , score_web_lr , '2') ;
% 
% score_mail_lr = msr_score_test_lr(:,3) - max(msr_score_test_lr(:,1) , msr_score_test_lr(:,2)) ;
% [~ , ~ , ~ , msr_auc_mail_lr] = perfcurve(msr_label_test , score_mail_lr , '3') ;
% 
% msr_accuracy_rate_lr = sum(( msr_predict_test_lr ==  msr_label_test)) / N_msr_test ;
% 
% msr_confusion_lr = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         msr_confusion_lr(i_pred,i_test) = sum( (msr_predict_test_lr == i_pred) & (msr_label_test == i_test) ) ;
%     end
% end
% 
% msr_tp_lr = diag(msr_confusion_lr)' ;
% msr_fp_lr = diag(msr_confusion_lr * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% msr_fn_lr = diag(msr_confusion_lr' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
% 
% msr_precision_lr = msr_tp_lr ./ (msr_tp_lr + msr_fp_lr) ;
% msr_recall_lr = msr_tp_lr ./ (msr_tp_lr + msr_fn_lr) ;
% %%%

%%% logged
msr_prob_test_lr_log = mnrval( fiu_model_lr_log , msr_feature_test_log) ;
msr_predict_test_lr_log = (msr_prob_test_lr_log == max(msr_prob_test_lr_log,[],2)) * [1 2 3]' ;

msr_score_test_lr_log = msr_prob_test_lr_log ;

score_home_lr_log = msr_score_test_lr_log(:,1) - max(msr_score_test_lr_log(:,2) , msr_score_test_lr_log(:,3)) ;
[~ , ~ , ~ , msr_auc_home_lr_log] = perfcurve(msr_label_test , score_home_lr_log , '1') ;

score_web_lr_log = msr_score_test_lr_log(:,2) - max(msr_score_test_lr_log(:,1) , msr_score_test_lr_log(:,3)) ;
[~ , ~ , ~ , msr_auc_web_lr_log] = perfcurve(msr_label_test , score_web_lr_log , '2') ;

score_mail_lr_log = msr_score_test_lr_log(:,3) - max(msr_score_test_lr_log(:,1) , msr_score_test_lr_log(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_lr_log] = perfcurve(msr_label_test , score_mail_lr_log , '3') ;

msr_accuracy_rate_lr_log = sum(( msr_predict_test_lr_log ==  msr_label_test)) / N_msr_test ;

msr_confusion_lr_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        msr_confusion_lr_log(i_pred,i_test_log) = sum( (msr_predict_test_lr_log == i_pred) & (msr_label_test == i_test_log) ) ;
    end
end

msr_tp_lr_log = diag(msr_confusion_lr_log)' ;
msr_fp_lr_log = diag(msr_confusion_lr_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_lr_log = diag(msr_confusion_lr_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_lr_log = msr_tp_lr_log ./ (msr_tp_lr_log + msr_fp_lr_log) ;
msr_recall_lr_log = msr_tp_lr_log ./ (msr_tp_lr_log + msr_fn_lr_log) ;
%%%

%%
ii = 3 ;

x = [fiu_accuracy_rate_tree_log msr_accuracy_rate_tree_log ...
    fiu_auc_home_tree_log msr_auc_home_tree_log ...
    fiu_precision_tree_log(:,ii) msr_precision_tree_log(:,ii) ...
    fiu_recall_tree_log(:,ii) msr_recall_tree_log(:,ii) ; ...
    fiu_accuracy_rate_nb_log msr_accuracy_rate_nb_log ...
    fiu_auc_home_nb_log msr_auc_home_nb_log ...
    fiu_precision_nb_log(:,ii) msr_precision_nb_log(:,ii) ...
    fiu_recall_nb_log(:,ii) msr_recall_nb_log(:,ii) ; ...
    fiu_accuracy_rate_lr_log msr_accuracy_rate_lr_log ...
    fiu_auc_home_lr_log msr_auc_home_lr_log ...
    fiu_precision_lr_log(:,ii) msr_precision_lr_log(:,ii) ...
    fiu_recall_lr_log(:,ii) msr_recall_lr_log(:,ii)] ;

csvwrite('x.csv',x) ;

% %%% non-logged
% accuracy_fiu_msr = [fiu_accuracy_rate_tree msr_accuracy_rate_tree ; ...
%     fiu_accuracy_rate_nb msr_accuracy_rate_nb ; ...
%     fiu_accuracy_rate_lr msr_accuracy_rate_lr ] ;
%
% auc_fiu_msr = [fiu_auc_tree msr_auc_tree ; ...
%     fiu_auc_nb msr_auc_nb ; ...
%     fiu_auc_lr msr_auc_lr ] ;
%
% precision_fiu_msr = [fiu_precision_tree(1) msr_precision_tree(1) ; ...
%     fiu_precision_nb(1) msr_precision_nb(1) ; ...
%     fiu_precision_lr(1) msr_precision_lr(1) ] ;
%
% recall_fiu_msr = [fiu_recall_tree(1) msr_recall_tree(1) ; ...
%     fiu_recall_nb(1) msr_recall_nb(1) ; ...
%     fiu_recall_lr(1) msr_recall_lr(1)] ;
% %%%
%
% %%% logged
% accuracy_fiu_msr_log = [fiu_accuracy_rate_tree_log msr_accuracy_rate_tree_log ; ...
%     fiu_accuracy_rate_nb_log msr_accuracy_rate_nb_log ; ...
%     fiu_accuracy_rate_lr_log msr_accuracy_rate_lr_log] ;
%
% auc_fiu_msr_log = [fiu_auc_tree_log msr_auc_tree_log ; ...
%     fiu_auc_nb_log msr_auc_nb_log ; ...
%     fiu_auc_lr_log msr_auc_lr_log] ;
%
% precision_fiu_msr_log = [fiu_precision_tree_log(1) msr_precision_tree_log(1) ; ...
%     fiu_precision_nb_log(1) msr_precision_nb_log(1) ; ...
%     fiu_precision_lr_log(1) msr_precision_lr_log(1) ] ;
%
% recall_fiu_msr_log = [fiu_recall_tree_log(1) msr_recall_tree_log(1) ; ...
%     fiu_recall_nb_log(1) msr_recall_nb_log(1) ; ...
%     fiu_recall_lr_log(1) msr_recall_lr_log(1)] ;
% %%%

%% Relative importance and logistic regression CI

%%%
fiu_feature_importance_log = fiu_model_tree_log.predictorImportance ;

fiu_coeff_lr_log = fiu_model_lr_log(2:end,:) ;
fiu_se_lr_log = fiu_stats_lr_log.se(2:end,:) ;
fiu_beta_lr_log = fiu_stats_lr_log.beta(2:end,:) ;
fiu_p_lr_log  = fiu_stats_lr_log.p(2:end,:) ;

% clear fiu_p_lr_log_str
%
% for i_coeff = 1 : size(fiu_home_coeff_sort,1)
%     for i_p = 1 : 2
%
%         if fiu_p_lr_log(i_coeff,i_p) < 0.001
%             fiu_p_lr_log_str{i_coeff,i_p} = '< 0.001' ;
%         else
%             fiu_p_lr_log_str{i_coeff,i_p} = num2str(round(fiu_p_lr_log(i_coeff,i_p)*1e3)/1e3) ;
%         end
%
%     end
% end

% fiu_p_lr_log = fiu_p_lr_log_str ;

fiu_UL_lr_log = fiu_beta_lr_log+ 1.96 * fiu_se_lr_log ;
fiu_LL_lr_log = fiu_beta_lr_log - 1.96 * fiu_se_lr_log ;

fiu_feature_corrcoef = corrcoef( fiu_feature_train ) ;
%%%

[~ , i_sort] = sort( fiu_feature_importance_log , 'descend' ) ;

fiu_feature_importance_log_sort = fiu_feature_importance_log(i_sort) ;
fiu_relative_feature_importance_log_sort = fiu_feature_importance_log_sort / max(fiu_feature_importance_log_sort) * 100 ;

variable_sort = variable(i_sort) ;

corr_thresh = 0.8 ;

fiu_feature_corr_mat = corrcoef( fiu_feature_train ) ;

[i_row , i_col] = find(abs(fiu_feature_corr_mat) > corr_thresh) ;

i_corr = [i_row i_col] ;

i_corr(i_corr(:,2) >= i_corr(:,1),:) = [ ] ;

i_discard = [ ] ;

for j_corr = 1 : size(i_corr,1)
    
    [~,i_min] = min([fiu_feature_importance_log(i_corr(j_corr,1)) fiu_feature_importance_log(i_corr(j_corr,2) )]) ;
    i_min = i_min(1) ;
    
    i_discard = [i_discard ; i_corr(j_corr,i_min)] ;
    
end

i_discard = unique(i_discard) ;

fiu_home_coeff_sort = fiu_coeff_lr_log(i_sort,1) ;
fiu_home_ci_sort = fiu_home_ci(i_sort,:) ;
fiu_home_p_sort = fiu_p_lr_log(i_sort,1) ;
fiu_home_se_sort = fiu_se_lr_log(i_sort,1) ;

fiu_web_coeff_sort = fiu_coeff_lr_log(i_sort,2) ;
fiu_web_ci_sort = fiu_web_ci(i_sort,:) ;
fiu_web_p_sort = fiu_p_lr_log(i_sort,2) ;
fiu_web_se_sort = fiu_se_lr_log(i_sort,2) ;

close all
figure(1)
subplot(2,1, 1)
C = categorical(variable_sort) ;
C = reordercats(C,variable_sort);
% hold on
bar(C , fiu_relative_feature_importance_log_sort)
% % text(1:8 , fiu_home_coeff_sort+1 , fiu_home_p_sort , 'Color' , 'blue' , 'FontSize', 20)
% % text(1:8 , fiu_web_coeff_sort+1 , fiu_web_p_sort , 'Color' , 'red', 'FontSize', 20)
% hold off
hold off

subplot(2, 1,2)
% hold on
stem(C, [fiu_web_p_sort fiu_home_p_sort])
% plot([fiu_home_coeff_sort fiu_home_coeff_sort]' , fiu_home_ci_sort')
% plot(C , fiu_home_coeff_sort)

% h = errorbar([fiu_home_coeff_sort fiu_web_coeff_sort] , [fiu_home_se_sort fiu_web_se_sort] ) ;
% h(1).CapSize = 20 ;
% h(1).LineWidth = 2 ;
% h(2).CapSize = 20 ;
% h(2).LineWidth = 2 ;
% text(1:8 , fiu_home_coeff_sort+1 , fiu_home_p_sort , 'Color' , 'blue' , 'FontSize', 20)
% text(1:8 , fiu_web_coeff_sort+1 , fiu_web_p_sort , 'Color' , 'red', 'FontSize', 20)
% hold off

i_keep = [1 2 4 5 6 7 8] ; % find(fiu_relative_feature_importance_log_sort ~= 0) ;

variable_r = variable(i_keep) ;

fiu_feature_train_r_log = fiu_feature_train_log( : , i_keep) ;
fiu_feature_test_r_log = fiu_feature_test_log( : , i_keep) ;

msr_feature_test_r_log = msr_feature_test_log( : , i_keep) ;

%% Classification Tree (FIU data)

fiu_model_tree_r_log = ...
    fitctree( fiu_feature_train_r_log , fiu_label_train , ...
    'MinLeafSize' , 20 , ...
    'OptimizeHyperparameters' , {'MaxNumSplits'} , ...
    'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

MaxSplits = fiu_model_tree_r_log.ModelParameters.MaxSplits ;
MinLeaf = fiu_model_tree_r_log.ModelParameters.MinLeaf ;

%%

fiu_model_tree_r_log = ...
    fitctree( fiu_feature_train_r_log , fiu_label_train , ...
    'MinLeafSize' , 20 , ...
    'MaxNumSplits' , MaxSplits) ;

% %%% non-logged
% [fiu_predict_test_tree_r , fiu_score_test_tree_r ] = predict( fiu_model_tree_r , fiu_feature_test_r ) ;
%
% score_home_tree_r = fiu_score_test_tree_r(:,1) - max(fiu_score_test_tree_r(:,2) , fiu_score_test_tree_r(:,3)) ;
% [~ , ~ , ~ , fiu_auc_home_tree_r] = perfcurve(fiu_label_test , score_home_tree_r , '1') ;
%
% score_web_tree_r = fiu_score_test_tree_r(:,2) - max(fiu_score_test_tree_r(:,1) , fiu_score_test_tree_r(:,3)) ;
% [~ , ~ , ~ , fiu_auc_web_tree_r] = perfcurve(fiu_label_test , score_web_tree_r , '2') ;
%
% score_mail_tree_r = fiu_score_test_tree_r(:,3) - max(fiu_score_test_tree_r(:,1) , fiu_score_test_tree_r(:,2)) ;
% [~ , ~ , ~ , fiu_auc_mail_tree_r] = perfcurve(fiu_label_test , score_mail_tree_r , '3') ;
%
% fiu_accuracy_rate_tree_r = sum(( fiu_predict_test_tree_r ==  fiu_label_test)) / N_fiu_test ;
%
% fiu_confusion_tree_r = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         fiu_confusion_tree_r(i_pred,i_test) = sum( (fiu_predict_test_tree_r == i_pred) & (fiu_label_test == i_test) ) ;
%     end
% end
%
% fiu_tp_tree_r = diag(fiu_confusion_tree_r)' ;
% fiu_fp_tree_r = diag(fiu_confusion_tree_r * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% fiu_fn_tree_r = diag(fiu_confusion_tree_r' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
%
% fiu_precision_tree_r = fiu_tp_tree_r ./ (fiu_tp_tree_r + fiu_fp_tree_r) ;
% fiu_recall_tree_r = fiu_tp_tree_r ./ (fiu_tp_tree_r + fiu_fn_tree_r) ;
% %%%

%%% logged
[fiu_predict_test_tree_r_log , fiu_score_test_tree_r_log ] = predict( fiu_model_tree_r_log , fiu_feature_test_r_log ) ;

score_home_tree_r_log = fiu_score_test_tree_r_log(:,1) - max(fiu_score_test_tree_r_log(:,2) , fiu_score_test_tree_r_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_tree_r_log] = perfcurve(fiu_label_test , score_home_tree_r_log , '1') ;

score_web_tree_r_log = fiu_score_test_tree_r_log(:,2) - max(fiu_score_test_tree_r_log(:,1) , fiu_score_test_tree_r_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_tree_r_log] = perfcurve(fiu_label_test , score_web_tree_r_log , '2') ;

score_mail_tree_r_log = fiu_score_test_tree_r_log(:,3) - max(fiu_score_test_tree_r_log(:,1) , fiu_score_test_tree_r_log(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_tree_r_log] = perfcurve(fiu_label_test , score_mail_tree_r_log , '3') ;

fiu_accuracy_rate_tree_r_log = sum(( fiu_predict_test_tree_r_log ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_tree_r_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        fiu_confusion_tree_r_log(i_pred,i_test_log) = sum( (fiu_predict_test_tree_r_log == i_pred) & (fiu_label_test == i_test_log) ) ;
    end
end

fiu_tp_tree_r_log = diag(fiu_confusion_tree_r_log)' ;
fiu_fp_tree_r_log = diag(fiu_confusion_tree_r_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_tree_r_log = diag(fiu_confusion_tree_r_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_tree_r_log = fiu_tp_tree_r_log ./ (fiu_tp_tree_r_log + fiu_fp_tree_r_log) ;
fiu_recall_tree_r_log = fiu_tp_tree_r_log ./ (fiu_tp_tree_r_log + fiu_fn_tree_r_log) ;
%%%

%% Naive Bayes Classification (FIU Data)

% z_fiu_feature_train_r = zscore(fiu_feature_train_r) ;
z_fiu_feature_train_r_log = zscore(fiu_feature_train_r_log) ;
z_fiu_feature_test_r_log = zscore(fiu_feature_test_r_log) ;
z_msr_feature_test_r_log = zscore(msr_feature_test_r_log) ;

% fiu_model_nb_r = ...
%     fitcnb( z_fiu_feature_train_r , fiu_label_train , ...
%     'DistributionNames' , 'Kernel' , ...
%     'OptimizeHyperparameters' , {'Width'} , ...
%     'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

fiu_model_nb_r_log = ...
    fitcnb( z_fiu_feature_train_r_log , fiu_label_train , ...
    'DistributionNames' , 'Kernel' , ...
    'OptimizeHyperparameters' , {'Width'} , ...
    'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;

%%

% %%% non-logged
% [fiu_predict_test_nb_r , fiu_score_test_nb_r ] = predict( fiu_model_nb_r , fiu_feature_test_r ) ;
%
% score_home_nb_r = fiu_score_test_nb_r(:,1) - max(fiu_score_test_nb_r(:,2) , fiu_score_test_nb_r(:,3)) ;
% [~ , ~ , ~ , fiu_auc_home_nb_r] = perfcurve(fiu_label_test , score_home_nb_r , '1') ;
%
% score_web_nb_r = fiu_score_test_nb_r(:,2) - max(fiu_score_test_nb_r(:,1) , fiu_score_test_nb_r(:,3)) ;
% [~ , ~ , ~ , fiu_auc_web_nb_r] = perfcurve(fiu_label_test , score_web_nb_r , '2') ;
%
% score_mail_nb_r = fiu_score_test_nb_r(:,3) - max(fiu_score_test_nb_r(:,1) , fiu_score_test_nb_r(:,2)) ;
% [~ , ~ , ~ , fiu_auc_mail_nb_r] = perfcurve(fiu_label_test , score_mail_nb_r , '3') ;
%
% fiu_accuracy_rate_nb_r = sum(( fiu_predict_test_nb_r ==  fiu_label_test)) / N_fiu_test ;
%
% fiu_confusion_nb_r = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         fiu_confusion_nb_r(i_pred,i_test) = sum( (fiu_predict_test_nb_r == i_pred) & (fiu_label_test == i_test) ) ;
%     end
% end
%
% fiu_tp_nb_r = diag(fiu_confusion_nb_r)' ;
% fiu_fp_nb_r = diag(fiu_confusion_nb_r * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% fiu_fn_nb_r = diag(fiu_confusion_nb_r' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
%
% fiu_precision_nb_r = fiu_tp_nb_r ./ (fiu_tp_nb_r + fiu_fp_nb_r) ;
% fiu_recall_nb_r = fiu_tp_nb_r ./ (fiu_tp_nb_r + fiu_fn_nb_r) ;
% %%%

%%% logged
[fiu_predict_test_nb_r_log , fiu_score_test_nb_r_log ] = predict( fiu_model_nb_r_log , z_fiu_feature_test_r_log ) ;

score_home_nb_r_log = fiu_score_test_nb_r_log(:,1) - max(fiu_score_test_nb_r_log(:,2) , fiu_score_test_nb_r_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_nb_r_log] = perfcurve(fiu_label_test , score_home_nb_r_log , '1') ;

score_web_nb_r_log = fiu_score_test_nb_r_log(:,2) - max(fiu_score_test_nb_r_log(:,1) , fiu_score_test_nb_r_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_nb_r_log] = perfcurve(fiu_label_test , score_web_nb_r_log , '2') ;

score_mail_nb_r_log = fiu_score_test_nb_r_log(:,3) - max(fiu_score_test_nb_r_log(:,1) , fiu_score_test_nb_r_log(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_nb_r_log] = perfcurve(fiu_label_test , score_mail_nb_r_log , '3') ;

fiu_accuracy_rate_nb_r_log = sum(( fiu_predict_test_nb_r_log ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_nb_r_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        fiu_confusion_nb_r_log(i_pred,i_test_log) = sum( (fiu_predict_test_nb_r_log == i_pred) & (fiu_label_test == i_test_log) ) ;
    end
end

fiu_tp_nb_r_log = diag(fiu_confusion_nb_r_log)' ;
fiu_fp_nb_r_log = diag(fiu_confusion_nb_r_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_nb_r_log = diag(fiu_confusion_nb_r_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_nb_r_log = fiu_tp_nb_r_log ./ (fiu_tp_nb_r_log + fiu_fp_nb_r_log) ;
fiu_recall_nb_r_log = fiu_tp_nb_r_log ./ (fiu_tp_nb_r_log + fiu_fn_nb_r_log) ;
%%%

%% Multinomial Logistic Regression (FIU Data)

% %%% non-logged
% [fiu_model_lr_r , fiu_dev_lr_r , fiu_stats_lr_r] =  mnrfit( fiu_feature_train_r , categorical(fiu_label_train) ) ;
%
% fiu_UL_lr_r = fiu_stats_lr_r.beta + 1.96 * fiu_stats_lr_r.se ;
% fiu_LL_lr_r = fiu_stats_lr_r.beta - 1.96 * fiu_stats_lr_r.se ;
% %%%

%%% logged
[fiu_model_lr_r_log , fiu_dev_lr_r_log , fiu_stats_lr_r_log] =  mnrfit( fiu_feature_train_r_log , categorical(fiu_label_train) ) ;

fiu_UL_lr_r_log = fiu_stats_lr_r_log.beta + 1.96 * fiu_stats_lr_r_log.se ;
fiu_LL_lr_r_log = fiu_stats_lr_r_log.beta - 1.96 * fiu_stats_lr_r_log.se ;
%%%

%%

% %%% non-logged
% fiu_prob_test_lr_r = mnrval( fiu_model_lr_r , fiu_feature_test_r) ;
% fiu_predict_test_lr_r = (fiu_prob_test_lr_r == max(fiu_prob_test_lr_r,[],2)) * [1 2 3]' ;
%
% fiu_score_test_lr_r = fiu_prob_test_lr_r ;
%
% score_home_lr_r = fiu_score_test_lr_r(:,1) - max(fiu_score_test_lr_r(:,2) , fiu_score_test_lr_r(:,3)) ;
% [~ , ~ , ~ , fiu_auc_home_lr_r] = perfcurve(fiu_label_test , score_home_lr_r , '1') ;
%
% score_web_lr_r = fiu_score_test_lr_r(:,2) - max(fiu_score_test_lr_r(:,1) , fiu_score_test_lr_r(:,3)) ;
% [~ , ~ , ~ , fiu_auc_web_lr_r] = perfcurve(fiu_label_test , score_web_lr_r , '2') ;
%
% score_mail_lr_r = fiu_score_test_lr_r(:,3) - max(fiu_score_test_lr_r(:,1) , fiu_score_test_lr_r(:,2)) ;
% [~ , ~ , ~ , fiu_auc_mail_lr_r] = perfcurve(fiu_label_test , score_mail_lr_r , '3') ;
%
% fiu_accuracy_rate_lr_r = sum(( fiu_predict_test_lr_r ==  fiu_label_test)) / N_fiu_test ;
%
% fiu_confusion_lr_r = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         fiu_confusion_lr_r(i_pred,i_test) = sum( (fiu_predict_test_lr_r == i_pred) & (fiu_label_test == i_test) ) ;
%     end
% end
%
% fiu_tp_lr_r = diag(fiu_confusion_lr_r)' ;
% fiu_fp_lr_r = diag(fiu_confusion_lr_r * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% fiu_fn_lr_r = diag(fiu_confusion_lr_r' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
%
% fiu_precision_lr_r = fiu_tp_lr_r ./ (fiu_tp_lr_r + fiu_fp_lr_r) ;
% fiu_recall_lr_r = fiu_tp_lr_r ./ (fiu_tp_lr_r + fiu_fn_lr_r) ;
% %%%

%%% logged
fiu_prob_test_lr_r_log = mnrval( fiu_model_lr_r_log , fiu_feature_test_r_log) ;
fiu_predict_test_lr_r_log = (fiu_prob_test_lr_r_log == max(fiu_prob_test_lr_r_log,[],2)) * [1 2 3]' ;

fiu_score_test_lr_r_log = fiu_prob_test_lr_r_log ;

score_home_lr_r_log = fiu_score_test_lr_r_log(:,1) - max(fiu_score_test_lr_r_log(:,2) , fiu_score_test_lr_r_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_home_lr_r_log] = perfcurve(fiu_label_test , score_home_lr_r_log , '1') ;

score_web_lr_r_log = fiu_score_test_lr_r_log(:,2) - max(fiu_score_test_lr_r_log(:,1) , fiu_score_test_lr_r_log(:,3)) ;
[~ , ~ , ~ , fiu_auc_web_lr_r_log] = perfcurve(fiu_label_test , score_web_lr_r_log , '2') ;

score_mail_lr_r_log = fiu_score_test_lr_r_log(:,3) - max(fiu_score_test_lr_r_log(:,1) , fiu_score_test_lr_r_log(:,2)) ;
[~ , ~ , ~ , fiu_auc_mail_lr_r_log] = perfcurve(fiu_label_test , score_mail_lr_r_log , '3') ;

fiu_accuracy_rate_lr_r_log = sum(( fiu_predict_test_lr_r_log ==  fiu_label_test)) / N_fiu_test ;

fiu_confusion_lr_r_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        fiu_confusion_lr_r_log(i_pred,i_test_log) = sum( (fiu_predict_test_lr_r_log == i_pred) & (fiu_label_test == i_test_log) ) ;
    end
end

fiu_tp_lr_r_log = diag(fiu_confusion_lr_r_log)' ;
fiu_fp_lr_r_log = diag(fiu_confusion_lr_r_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
fiu_fn_lr_r_log = diag(fiu_confusion_lr_r_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

fiu_precision_lr_r_log = fiu_tp_lr_r_log ./ (fiu_tp_lr_r_log + fiu_fp_lr_r_log) ;
fiu_recall_lr_r_log = fiu_tp_lr_r_log ./ (fiu_tp_lr_r_log + fiu_fn_lr_r_log) ;
%%%

%% Classification Tree (MSR data)

% %%% non-logged
% [msr_predict_test_tree_r , msr_score_test_tree_r ] = predict( fiu_model_tree_r , msr_feature_test_r ) ;
%
% score_home_tree_r = msr_score_test_tree_r(:,1) - max(msr_score_test_tree_r(:,2) , msr_score_test_tree_r(:,3)) ;
% [~ , ~ , ~ , msr_auc_home_tree_r] = perfcurve(msr_label_test , score_home_tree_r , '1') ;
%
% score_web_tree_r = msr_score_test_tree_r(:,2) - max(msr_score_test_tree_r(:,1) , msr_score_test_tree_r(:,3)) ;
% [~ , ~ , ~ , msr_auc_web_tree_r] = perfcurve(msr_label_test , score_web_tree_r , '2') ;
%
% score_mail_tree_r = msr_score_test_tree_r(:,3) - max(msr_score_test_tree_r(:,1) , msr_score_test_tree_r(:,2)) ;
% [~ , ~ , ~ , msr_auc_mail_tree_r] = perfcurve(msr_label_test , score_mail_tree_r , '3') ;
%
% msr_accuracy_rate_tree_r = sum(( msr_predict_test_tree_r ==  msr_label_test)) / N_msr_test ;
%
% msr_confusion_tree_r = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         msr_confusion_tree_r(i_pred,i_test) = sum( (msr_predict_test_tree_r == i_pred) & (msr_label_test == i_test) ) ;
%     end
% end
%
% msr_tp_tree_r = diag(msr_confusion_tree_r)' ;
% msr_fp_tree_r = diag(msr_confusion_tree_r * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% msr_fn_tree_r = diag(msr_confusion_tree_r' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
%
% msr_precision_tree_r = msr_tp_tree_r ./ (msr_tp_tree_r + msr_fp_tree_r) ;
% msr_recall_tree_r = msr_tp_tree_r ./ (msr_tp_tree_r + msr_fn_tree_r) ;
% %%%

%%% logged
[msr_predict_test_tree_r_log , msr_score_test_tree_r_log ] = predict( fiu_model_tree_r_log , msr_feature_test_r_log ) ;

score_home_tree_r_log = msr_score_test_tree_r_log(:,1) - max(msr_score_test_tree_r_log(:,2) , msr_score_test_tree_r_log(:,3)) ;
[~ , ~ , ~ , msr_auc_home_tree_r_log] = perfcurve(msr_label_test , score_home_tree_r_log , '1') ;

score_web_tree_r_log = msr_score_test_tree_r_log(:,2) - max(msr_score_test_tree_r_log(:,1) , msr_score_test_tree_r_log(:,3)) ;
[~ , ~ , ~ , msr_auc_web_tree_r_log] = perfcurve(msr_label_test , score_web_tree_r_log , '2') ;

score_mail_tree_r_log = msr_score_test_tree_r_log(:,3) - max(msr_score_test_tree_r_log(:,1) , msr_score_test_tree_r_log(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_tree_r_log] = perfcurve(msr_label_test , score_mail_tree_r_log , '3') ;

msr_accuracy_rate_tree_r_log = sum(( msr_predict_test_tree_r_log ==  msr_label_test)) / N_msr_test ;

msr_confusion_tree_r_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        msr_confusion_tree_r_log(i_pred,i_test_log) = sum( (msr_predict_test_tree_r_log == i_pred) & (msr_label_test == i_test_log) ) ;
    end
end

msr_tp_tree_r_log = diag(msr_confusion_tree_r_log)' ;
msr_fp_tree_r_log = diag(msr_confusion_tree_r_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_tree_r_log = diag(msr_confusion_tree_r_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_tree_r_log = msr_tp_tree_r_log ./ (msr_tp_tree_r_log + msr_fp_tree_r_log) ;
msr_recall_tree_r_log = msr_tp_tree_r_log ./ (msr_tp_tree_r_log + msr_fn_tree_r_log) ;
%%%

%% Naive Bayes Classification (MSR Data)

% %%% non-logged
% [msr_predict_test_nb_r , msr_score_test_nb_r ] = predict( fiu_model_nb_r , msr_feature_test_r ) ;
%
% score_home_nb_r = msr_score_test_nb_r(:,1) - max(msr_score_test_nb_r(:,2) , msr_score_test_nb_r(:,3)) ;
% [~ , ~ , ~ , msr_auc_home_nb_r] = perfcurve(msr_label_test , score_home_nb_r , '1') ;
%
% score_web_nb_r = msr_score_test_nb_r(:,2) - max(msr_score_test_nb_r(:,1) , msr_score_test_nb_r(:,3)) ;
% [~ , ~ , ~ , msr_auc_web_nb_r] = perfcurve(msr_label_test , score_web_nb_r , '2') ;
%
% score_mail_nb_r = msr_score_test_nb_r(:,3) - max(msr_score_test_nb_r(:,1) , msr_score_test_nb_r(:,2)) ;
% [~ , ~ , ~ , msr_auc_mail_nb_r] = perfcurve(msr_label_test , score_mail_nb_r , '3') ;
%
% msr_accuracy_rate_nb_r = sum(( msr_predict_test_nb_r ==  msr_label_test)) / N_msr_test ;
%
% msr_confusion_nb_r = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         msr_confusion_nb_r(i_pred,i_test) = sum( (msr_predict_test_nb_r == i_pred) & (msr_label_test == i_test) ) ;
%     end
% end
%
% msr_tp_nb_r = diag(msr_confusion_nb_r)' ;
% msr_fp_nb_r = diag(msr_confusion_nb_r * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% msr_fn_nb_r = diag(msr_confusion_nb_r' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
%
% msr_precision_nb_r = msr_tp_nb_r ./ (msr_tp_nb_r + msr_fp_nb_r) ;
% msr_recall_nb_r = msr_tp_nb_r ./ (msr_tp_nb_r + msr_fn_nb_r) ;
% %%%

%%% logged
[msr_predict_test_nb_r_log , msr_score_test_nb_r_log ] = predict( fiu_model_nb_r_log , z_msr_feature_test_r_log ) ;

score_home_nb_r_log = msr_score_test_nb_r_log(:,1) - max(msr_score_test_nb_r_log(:,2) , msr_score_test_nb_r_log(:,3)) ;
[~ , ~ , ~ , msr_auc_home_nb_r_log] = perfcurve(msr_label_test , score_home_nb_r_log , '1') ;

score_web_nb_r_log = msr_score_test_nb_r_log(:,2) - max(msr_score_test_nb_r_log(:,1) , msr_score_test_nb_r_log(:,3)) ;
[~ , ~ , ~ , msr_auc_web_nb_r_log] = perfcurve(msr_label_test , score_web_nb_r_log , '2') ;

score_mail_nb_r_log = msr_score_test_nb_r_log(:,3) - max(msr_score_test_nb_r_log(:,1) , msr_score_test_nb_r_log(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_nb_r_log] = perfcurve(msr_label_test , score_mail_nb_r_log , '3') ;

msr_accuracy_rate_nb_r_log = sum(( msr_predict_test_nb_r_log ==  msr_label_test)) / N_msr_test ;

msr_confusion_nb_r_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        msr_confusion_nb_r_log(i_pred,i_test_log) = sum( (msr_predict_test_nb_r_log == i_pred) & (msr_label_test == i_test_log) ) ;
    end
end

msr_tp_nb_r_log = diag(msr_confusion_nb_r_log)' ;
msr_fp_nb_r_log = diag(msr_confusion_nb_r_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_nb_r_log = diag(msr_confusion_nb_r_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_nb_r_log = msr_tp_nb_r_log ./ (msr_tp_nb_r_log + msr_fp_nb_r_log) ;
msr_recall_nb_r_log = msr_tp_nb_r_log ./ (msr_tp_nb_r_log + msr_fn_nb_r_log) ;
%%%

%% Multinomial Logistic Regression (MSR Data)

% %%% non-logged
% msr_prob_test_lr_r = mnrval( fiu_model_lr_r , msr_feature_test_r) ;
% msr_predict_test_lr_r = (msr_prob_test_lr_r == max(msr_prob_test_lr_r,[],2)) * [1 2 3]' ;
%
% msr_score_test_lr_r = msr_prob_test_lr_r ;
%
% score_home_lr_r = msr_score_test_lr_r(:,1) - max(msr_score_test_lr_r(:,2) , msr_score_test_lr_r(:,3)) ;
% [~ , ~ , ~ , msr_auc_home_lr_r] = perfcurve(msr_label_test , score_home_lr_r , '1') ;
%
% score_web_lr_r = msr_score_test_lr_r(:,2) - max(msr_score_test_lr_r(:,1) , msr_score_test_lr_r(:,3)) ;
% [~ , ~ , ~ , msr_auc_web_lr_r] = perfcurve(msr_label_test , score_web_lr_r , '2') ;
%
% score_mail_lr_r = msr_score_test_lr_r(:,3) - max(msr_score_test_lr_r(:,1) , msr_score_test_lr_r(:,2)) ;
% [~ , ~ , ~ , msr_auc_mail_lr_r] = perfcurve(msr_label_test , score_mail_lr_r , '3') ;
%
% msr_accuracy_rate_lr_r = sum(( msr_predict_test_lr_r ==  msr_label_test)) / N_msr_test ;
%
% msr_confusion_lr_r = zeros(3) ;
% for i_pred = 1 : 3
%     for i_test = 1 : 3
%         msr_confusion_lr_r(i_pred,i_test) = sum( (msr_predict_test_lr_r == i_pred) & (msr_label_test == i_test) ) ;
%     end
% end
%
% msr_tp_lr_r = diag(msr_confusion_lr_r)' ;
% msr_fp_lr_r = diag(msr_confusion_lr_r * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
% msr_fn_lr_r = diag(msr_confusion_lr_r' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;
%
% msr_precision_lr_r = msr_tp_lr_r ./ (msr_tp_lr_r + msr_fp_lr_r) ;
% msr_recall_lr_r = msr_tp_lr_r ./ (msr_tp_lr_r + msr_fn_lr_r) ;
% %%%

%%% logged
msr_prob_test_lr_r_log = mnrval( fiu_model_lr_r_log , msr_feature_test_r_log) ;
msr_predict_test_lr_r_log = (msr_prob_test_lr_r_log == max(msr_prob_test_lr_r_log,[],2)) * [1 2 3]' ;

msr_score_test_lr_r_log = msr_prob_test_lr_r_log ;

score_home_lr_r_log = msr_score_test_lr_r_log(:,1) - max(msr_score_test_lr_r_log(:,2) , msr_score_test_lr_r_log(:,3)) ;
[~ , ~ , ~ , msr_auc_home_lr_r_log] = perfcurve(msr_label_test , score_home_lr_r_log , '1') ;

score_web_lr_r_log = msr_score_test_lr_r_log(:,2) - max(msr_score_test_lr_r_log(:,1) , msr_score_test_lr_r_log(:,3)) ;
[~ , ~ , ~ , msr_auc_web_lr_r_log] = perfcurve(msr_label_test , score_web_lr_r_log , '2') ;

score_mail_lr_r_log = msr_score_test_lr_r_log(:,3) - max(msr_score_test_lr_r_log(:,1) , msr_score_test_lr_r_log(:,2)) ;
[~ , ~ , ~ , msr_auc_mail_lr_r_log] = perfcurve(msr_label_test , score_mail_lr_r_log , '3') ;

msr_accuracy_rate_lr_r_log = sum(( msr_predict_test_lr_r_log ==  msr_label_test)) / N_msr_test ;

msr_confusion_lr_r_log = zeros(3) ;
for i_pred = 1 : 3
    for i_test_log = 1 : 3
        msr_confusion_lr_r_log(i_pred,i_test_log) = sum( (msr_predict_test_lr_r_log == i_pred) & (msr_label_test == i_test_log) ) ;
    end
end

msr_tp_lr_r_log = diag(msr_confusion_lr_r_log)' ;
msr_fp_lr_r_log = diag(msr_confusion_lr_r_log * [0 1 1 ; 1 0 1 ; 1 1 0]')' ;
msr_fn_lr_r_log = diag(msr_confusion_lr_r_log' * [0 1 1 ; 1 0 1 ; 1 1 0])' ;

msr_precision_lr_r_log = msr_tp_lr_r_log ./ (msr_tp_lr_r_log + msr_fp_lr_r_log) ;
msr_recall_lr_r_log = msr_tp_lr_r_log ./ (msr_tp_lr_r_log + msr_fn_lr_r_log) ;
%%%

%%
ii = 1 ;

x = [fiu_accuracy_rate_tree_r_log msr_accuracy_rate_tree_r_log ...
    fiu_auc_home_tree_r_log msr_auc_home_tree_r_log ...
    fiu_precision_tree_r_log(:,ii) msr_precision_tree_r_log(:,ii) ...
    fiu_recall_tree_r_log(:,ii) msr_recall_tree_r_log(:,ii) ; ...
    fiu_accuracy_rate_nb_r_log msr_accuracy_rate_nb_r_log ...
    fiu_auc_home_nb_r_log msr_auc_home_nb_r_log ...
    fiu_precision_nb_r_log(:,ii) msr_precision_nb_r_log(:,ii) ...
    fiu_recall_nb_r_log(:,ii) msr_recall_nb_r_log(:,ii) ; ...
    fiu_accuracy_rate_lr_r_log msr_accuracy_rate_lr_r_log ...
    fiu_auc_home_lr_r_log msr_auc_home_lr_r_log ...
    fiu_precision_lr_r_log(:,ii) msr_precision_lr_r_log(:,ii) ...
    fiu_recall_lr_r_log(:,ii) msr_recall_lr_r_log(:,ii)] ;

%%

%%% logged
accuracy_fiu_msr_log_r = [fiu_accuracy_rate_tree_log_r msr_accuracy_rate_tree_log_r ; ...
    fiu_accuracy_rate_nb_log_r msr_accuracy_rate_nb_log_r ; ...
    fiu_accuracy_rate_lr_log_r msr_accuracy_rate_lr_log_r] ;

auc_fiu_msr_log_r = [fiu_auc_tree_log_r msr_auc_tree_log_r ; ...
    fiu_auc_nb_log_r msr_auc_nb_log_r ; ...
    fiu_auc_lr_log_r msr_auc_lr_log_r] ;

precision_fiu_msr_log_r = [fiu_precision_tree_log_r(1) msr_precision_tree_log_r(1) ; ...
    fiu_precision_nb_log_r(1) msr_precision_nb_log_r(1) ; ...
    fiu_precision_lr_log_r(1) msr_precision_lr_log_r(1) ] ;

recall_fiu_msr_log_r = [fiu_recall_tree_log_r(1) msrecall_tree_log_r(1) ; ...
    fiu_recall_nb_log_r(1) msrecall_nb_log_r(1) ; ...
    fiu_recall_lr_log_r(1) msrecall_lr_log_r(1)] ;
%%%

%% Relative importance and log_ristic regression CI

%%%
fiu_feature_importance_log_r = fiu_model_tree_log_r.predictorImportance ;

fiu_coeff_lr_log_r = fiu_model_lr_log_r(2:end,:) ;
fiu_se_lr_log_r = fiu_stats_lr_log_r.se(2:end,:) ;
fiu_beta_lr_log_r = fiu_stats_lr_log_r.beta(2:end,:) ;
fiu_p_lr_log_r  = fiu_stats_lr_log_r.p(2:end,:) ;

fiu_UL_lr_log_r = fiu_beta_lr_log_r+ 1.96 * fiu_se_lr_log_r ;
fiu_LL_lr_log_r = fiu_beta_lr_log_r - 1.96 * fiu_se_lr_log_r ;

fiu_feature_corrcoef = corrcoef( fiu_feature_train ) ;
%%%

[~ , i_sort] = sort( fiu_feature_importance_log_r , 'descend' ) ;

fiu_feature_importance_log_r_sort = fiu_feature_importance_log_r(i_sort) ;
fiu_relative_feature_importance_log_r_sort = fiu_feature_importance_log_r_sort / max(fiu_feature_importance_log_r_sort) * 100 ;

corr_thresh = 0.8 ;

fiu_feature_corr_mat = corrcoef( fiu_feature_train ) ;

[i_row , i_col] = find(abs(fiu_feature_corr_mat) > corr_thresh) ;

i_corr = [i_row i_col] ;

i_corr(i_corr(:,2) >= i_corr(:,1),:) = [ ] ;

i_discard = [ ] ;

for j_corr = 1 : size(i_corr,1)
    
    [~,i_min] = min([fiu_feature_importance_log_r(i_corr(j_corr,1)) fiu_feature_importance_log_r(i_corr(j_corr,2) )]) ;
    i_min = i_min(1) ;
    
    i_discard = [i_discard ; i_corr(j_corr,i_min)] ;
    
end

i_discard = unique(i_discard) ;

variable(i_discard)

fiu_home_ci = [fiu_LL_lr(:,1) fiu_UL_lr(:,1)] ;
fiu_web_ci = [fiu_LL_lr(:,2) fiu_UL_lr(:,2)] ;

variable_sort = variable(i_sort) ;

fiu_home_coeff_sort = fiu_coeff_lr_log_r(i_sort,1) ;
fiu_home_ci_sort = fiu_home_ci(i_sort,:) ;
fiu_home_p_sort = fiu_p_lr_log_r(i_sort,1) ;
fiu_home_se_sort = fiu_se_lr_log_r(i_sort,1) ;

fiu_web_coeff_sort = fiu_coeff_lr_log_r(i_sort,2) ;
fiu_web_ci_sort = fiu_web_ci(i_sort,:) ;
fiu_web_p_sort = fiu_p_lr_log_r(i_sort,2) ;
fiu_web_se_sort = fiu_se_lr_log_r(i_sort,2) ;

close all
figure(1)
subplot(2,1, 1)
C = categorical(variable_sort) ;
C = reordercats(C,variable_sort);

bar(C , fiu_relative_feature_importance_log_r_sort)

hold off

subplot(2, 1,2)

stem(C, [fiu_web_p_sort fiu_home_p_sort])

i_keep = find(fiu_relative_feature_importance_log_r_sort ~= 0) ;

variable_r = variable_sort(i_keep) ;

fiu_feature_train_r_log = fiu_feature_train_r_log( : , i_keep) ;
fiu_feature_test_r_log = fiu_feature_test_r_log( : , i_keep) ;

msr_feature_test_r_log = msr_feature_test_r_log( : , i_keep) ;

%%

% [C, ptsC, centres] = dbscan( fiu_msr_feature' , 1, 100) ;
% [C_log, ptsC_log, centres_log] = dbscan( fiu_msr_feature_log' , 1, 100) ;

%%

clusters = [2 : 5] ;

label_fiu_train_k = [ ] ;
label_fiu_test_k = [ ] ;
label_msr_test_k = [ ] ;
label_k = [ ] ;

j_temp = [ones(N_fiu_train,1) ; 2*ones(N_fiu_test,1) ; 3 * ones(N_msr_test,1)] ;

data_temp = [fiu_feature_train_log ; fiu_feature_test_log ; msr_feature_test_log] ;

i_shuffle = randperm(size(data_temp,1),size(data_temp,1));

j_shuffle = j_temp(i_shuffle) ;
data_shuffle = data_temp(i_shuffle,:) ;

label_all = [ ] ;

n = 0 ;

for k = clusters
    
    n = n + 1 ;
    
    label_temp = kmeans( data_shuffle , k ) ;
    
    if k == 2
        label_temp = label_temp - 1 ;
    end
    
    label_all = [label_all label_temp] ;
    
    disp([num2str(n/length(clusters)*100) '%'])
    
end

label_fiu_train_k = label_all( j_shuffle == 1 , :) ;
label_fiu_test_k = label_all( j_shuffle == 2 , :) ;
label_msr_test_k = label_all( j_shuffle == 3 , :) ;

%%

clear fiu_model_tree_log_k fiu_predict_test_tree_log_k fiu_predict_test_tree_log_k fiu_accuracy_rate_tree_log_k fiu_predict_test_tree_log_k ...
    fiu_tp_tree_log fiu_fp_tree_log fiu_fn_tree_log fiu_precision_tree_log fiu_recall_tree_log ...
    msr_model_tree_log_k msr_predict_test_tree_log_k msr_predict_test_tree_log_k msr_accuracy_rate_tree_log_k msr_predict_test_tree_log_k ...
    msr_tp_tree_log msr_fp_tree_log msr_fn_tree_log msr_precision_tree_log msr_recall_tree_log

for k = 1 : size( label_fiu_test_k , 2)
    
    label_temp = unique(label_fiu_test_k(:,k))' ;
    y = numel(label_temp) ;
    
    fiu_model_tree_log_k{k} = ...
        fitctree( fiu_feature_train_log , label_fiu_train_k(:,k) , ...
        'OptimizeHyperparameters' , {'MaxNumSplits' , 'MinLeafSize'} , ...
        'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;
    
    %%% fiu
    [fiu_predict_test_tree_log_k{k} , fiu_score_test_tree_log_k ] = predict( fiu_model_tree_log_k{k} , fiu_feature_test_log ) ;
    
    %     if y > 2
    %         score_temp = fiu_score_test_tree_log_k(:,1) - max(fiu_score_test_tree_log_k(:,2:end),[],2) ;
    %     else
    %         score_temp = fiu_score_test_tree_log_k(:,2) ;
    %     end
    %
    % [~ , ~ , ~ , fiu_auc_tree_log_k{k}] = perfcurve(label_fiu_test_k(:,k) , score_temp , '1') ;
    
    fiu_accuracy_rate_tree_log_k{k} = sum(( fiu_predict_test_tree_log_k{k} ==  label_fiu_test_k(:,k))) / N_fiu_test ;
    
    fiu_confusion_tree_log = zeros(y) ;
    j_pred = 0 ;
    for i_pred = label_temp
        j_pred = j_pred + 1 ;
        j_test = 0 ;
        for i_test = label_temp
            j_test = j_test + 1 ;
            fiu_confusion_tree_log(j_pred,j_test) = sum( (fiu_predict_test_tree_log_k{k} == i_pred) & (label_fiu_test_k(:,k)  == i_test) ) ;
        end
    end
    
    transfer = eye( y ) ~= 1 ;
    
    fiu_tp_tree_log{k} = diag(fiu_confusion_tree_log)' ;
    fiu_fp_tree_log{k} = diag(fiu_confusion_tree_log * transfer')' ;
    fiu_fn_tree_log{k} = diag(fiu_confusion_tree_log' * transfer)' ;
    
    fiu_precision_tree_log{k} = fiu_tp_tree_log{k} ./ (fiu_tp_tree_log{k} + fiu_fp_tree_log{k}) ;
    fiu_recall_tree_log{k} = fiu_tp_tree_log{k} ./ (fiu_tp_tree_log{k} + fiu_fn_tree_log{k}) ;
    %%%
    
    %%% msr
    [msr_predict_test_tree_log_k{k} , msr_score_test_tree_log_k ] = predict( fiu_model_tree_log_k{k} , msr_feature_test_log ) ;
    
    %     if y > 2
    %         score_temp = msr_score_test_tree_log_k(:,1) - max(msr_score_test_tree_log_k(:,2:end),[],2) ;
    %     else
    %         score_temp = msr_score_test_tree_log_k(:,2) ;
    %     end
    %
    %     [~ , ~ , ~ , msr_auc_tree_log_k{k}] = perfcurve(label_msr_test_k(:,k) , score_temp , '1') ;
    
    msr_accuracy_rate_tree_log_k{k} = sum(( msr_predict_test_tree_log_k{k} ==  label_msr_test_k(:,k))) / N_msr_test ;
    
    msr_confusion_tree_log = zeros(y) ;
    j_pred = 0 ;
    for i_pred = label_temp
        j_pred = j_pred + 1 ;
        j_test = 0 ;
        for i_test = label_temp
            j_test = j_test + 1 ;
            msr_confusion_tree_log(j_pred,j_test) = sum( (msr_predict_test_tree_log_k{k} == i_pred) & (label_msr_test_k(:,k)  == i_test) ) ;
        end
    end
    
    transfer = eye( y ) ~= 1 ;
    
    msr_tp_tree_log{k} = diag(msr_confusion_tree_log)' ;
    msr_fp_tree_log{k} = diag(msr_confusion_tree_log * transfer')' ;
    msr_fn_tree_log{k} = diag(msr_confusion_tree_log' * transfer)' ;
    
    msr_precision_tree_log{k} = msr_tp_tree_log{k} ./ (msr_tp_tree_log{k} + msr_fp_tree_log{k}) ;
    msr_recall_tree_log{k} = msr_tp_tree_log{k} ./ (msr_tp_tree_log{k} + msr_fn_tree_log{k}) ;
    %%%
    
end

%%

clear fiu_predict_test_tree_log_k fiu_auc_tree_log_k fiu_accuracy_rate_tree_log_k ...
    fiu_tp_tree_log fiu_fp_tree_log fiu_fn_tree_log fiu_precision_tree_log fiu_recall_tree_log fiu_predict_test_tree_log_k ...
    msr_predict_test_tree_log_k msr_auc_tree_log_k msr_accuracy_rate_tree_log_k ...
    msr_tp_tree_log msr_fp_tree_log msr_fn_tree_log msr_precision_tree_log msr_recall_tree_log msr_predict_test_tree_log_k ...
    fiu_model_tree_log_k

fiu_accuracy_rate_tree_log = [ ] ;

for k = 1 : size(label_k , 2)
    
    label_temp = unique(label_k(:,k))' ;
    y = numel(label_temp) ;
    
    fiu_model_tree_log_k{k} = ...
        fitctree( fiu_feature_train_log , label_k(:,k) , ...
        'OptimizeHyperparameters' , {'MaxNumSplits' , 'MinLeafSize'} , ...
        'HyperparameterOptimizationOptions' ,  struct('KFold' , 10) ) ; % , ... 'Verbose' , 0 , ... 'ShowPlots' , false) ;
    
    %%% fiu
    [fiu_predict_test_tree_log_k{k} , fiu_score_test_tree_log_k ] = predict( fiu_model_tree_log_k{k} , fiu_feature_test_log ) ;
    
    if y > 2
        score_temp = fiu_score_test_tree_log_k(:,1) - max(fiu_score_test_tree_log_k(:,2:end),[],2) ;
        target = '1' ;
    else
        score_temp = fiu_score_test_tree_log_k(:,2) ;
        target = '0' ;
    end
    
    [~ , ~ , ~ , fiu_auc_tree_log_k{k}] = perfcurve(label_k(:,k) , score_temp , target) ;
    
    fiu_accuracy_rate_tree_log_k{k} = sum(( fiu_predict_test_tree_log_k{k} ==  label_k(:,k))) / N_fiu_test ;
    
    fiu_confusion_tree_log = zeros(y) ;
    j_pred = 0 ;
    for i_pred = label_temp
        j_pred = j_pred + 1 ;
        j_test = 0 ;
        for i_test = label_temp
            j_test = j_test + 1 ;
            fiu_confusion_tree_log(j_pred,j_test) = sum( (fiu_predict_test_tree_log_k{k} == i_pred) & (label_k(:,k)  == i_test) ) ;
        end
    end
    
    transfer = eye( y ) ~= 1 ;
    
    fiu_tp_tree_log{k} = diag(fiu_confusion_tree_log)' ;
    fiu_fp_tree_log{k} = diag(fiu_confusion_tree_log * transfer')' ;
    fiu_fn_tree_log{k} = diag(fiu_confusion_tree_log' * transfer)' ;
    
    fiu_precision_tree_log{k} = fiu_tp_tree_log{k} ./ (fiu_tp_tree_log{k} + fiu_fp_tree_log{k}) ;
    fiu_recall_tree_log{k} = fiu_tp_tree_log{k} ./ (fiu_tp_tree_log{k} + fiu_fn_tree_log{k}) ;
    %%%
    
    %%% msr
    [msr_predict_test_tree_log_k{k} , msr_score_test_tree_log_k ] = predict( fiu_model_tree_log_k{k} , msr_feature_test ) ;
    
    if y > 2
        score_temp = msr_score_test_tree_log_k(:,1) - max(msr_score_test_tree_log_k(:,2:end),[],2) ;
        target = '1' ;
    else
        score_temp = msr_score_test_tree_log_k(:,2) ;
        target = '0' ;
    end
    
    [~ , ~ , ~ , msr_auc_tree_log_k{k}] = perfcurve(msr_label_k_test(:,k) , score_temp , target) ;
    
    msr_accuracy_rate_tree_log_k{k} = sum(( msr_predict_test_tree_log_k{k} ==  msr_label_k_test(:,k))) / N_msr_test ;
    
    msr_confusion_tree_log = zeros(y) ;
    j_pred = 0 ;
    for i_pred = label_temp
        j_pred = j_pred + 1 ;
        j_test = 0 ;
        for i_test = label_temp
            j_test = j_test + 1 ;
            msr_confusion_tree_log(j_pred,j_test) = sum( (msr_predict_test_tree_log_k{k} == i_pred) & (msr_label_k_test(:,k)  == i_test) ) ;
        end
    end
    
    transfer = eye( y ) ~= 1 ;
    
    msr_tp_tree_log{k} = diag(msr_confusion_tree_log)' ;
    msr_fp_tree_log{k} = diag(msr_confusion_tree_log * transfer')' ;
    msr_fn_tree_log{k} = diag(msr_confusion_tree_log' * transfer)' ;
    
    msr_precision_tree_log{k} = msr_tp_tree_log{k} ./ (msr_tp_tree_log{k} + msr_fp_tree_log{k}) ;
    msr_recall_tree_log{k} = msr_tp_tree_log{k} ./ (msr_tp_tree_log{k} + msr_fn_tree_log{k}) ;
    %%%
    
end

%%

clear fiu_predict_test_lr_log_k fiu_auc_lr_log_k fiu_accuracy_rate_lr_log_k ...
    fiu_tp_lr_log fiu_fp_lr_log fiu_fn_lr_log fiu_precision_lr_log fiu_recall_lr_log fiu_predict_test_lr_log_k ...
    msr_predict_test_lr_log_k msr_auc_lr_log_k msr_accuracy_rate_lr_log_k ...
    msr_tp_lr_log msr_fp_lr_log msr_fn_lr_log msr_precision_lr_log msr_recall_lr_log msr_predict_test_lr_log_k ...
    fiu_model_lr_log_k fiu_dev_lr_log_k fiu_stats_lr_log_k fiu_fp_lr_log_k fiu_tp_lr_log_k fiu_auc_lr_log_k ...
    fiu_model_lr_log_k msr_dev_lr_log_k msr_stats_lr_log_k msr_fp_lr_log_k msr_tp_lr_log_k msr_auc_lr_log_k

fiu_accuracy_rate_lr_log = [ ] ;

for k = 1 : size(label_k , 2)
    
    label_temp = unique(label_k(:,k))' ;
    y = numel(label_temp) ;
    
    %%% fiu
    [fiu_model_lr_log_k{k} , fiu_dev_lr_log_k{k} , fiu_stats_lr_log_k{k}] =  mnrfit( fiu_feature_train_log , categorical(label_k(:,k)) ) ;
    
    fiu_prob_test_lr_log = mnrval( fiu_model_lr_log_k{k}  , fiu_feature_test_log) ;
    fiu_predict_test_lr_log_k{k} = (fiu_prob_test_lr_log == max(fiu_prob_test_lr_log,[],2)) * (1 : y)' ;
    
    score_home_lr_log = fiu_prob_test_lr_log(:,1) - max(fiu_prob_test_lr_log , [ ] , 2) ;
    [fiu_fp_lr_log_k{k} , fiu_tp_lr_log_k{k} , ~ , fiu_auc_lr_log_k{k}] = perfcurve(label_k(:,k) , score_home_lr_log , '1') ;
    
    if y > 2
        score_temp = fiu_prob_test_lr_log(:,1) - max(fiu_prob_test_lr_log(:,2:end),[],2) ;
    else
        score_temp = fiu_prob_test_lr_log(:,2) ;
    end
    
    [~ , ~ , ~ , fiu_auc_lr_log_k{k}] = perfcurve(label_k(:,k) , score_temp , '1') ;
    
    fiu_accuracy_rate_lr_log_k{k} = sum(( fiu_predict_test_lr_log_k{k} ==  label_k(:,k))) / N_fiu_test ;
    
    fiu_confusion_lr_log = zeros(y) ;
    j_pred = 0 ;
    for i_pred = label_temp
        j_pred = j_pred + 1 ;
        j_test = 0 ;
        for i_test = label_temp
            j_test = j_test + 1 ;
            fiu_confusion_lr_log(j_pred,j_test) = sum( (fiu_predict_test_lr_log_k{k} == i_pred) & (label_k(:,k)  == i_test) ) ;
        end
    end
    
    transfer = eye( y ) ~= 1 ;
    
    fiu_tp_lr_log{k} = diag(fiu_confusion_lr_log)' ;
    fiu_fp_lr_log{k} = diag(fiu_confusion_lr_log * transfer')' ;
    fiu_fn_lr_log{k} = diag(fiu_confusion_lr_log' * transfer)' ;
    
    fiu_precision_lr_log{k} = fiu_tp_lr_log{k} ./ (fiu_tp_lr_log{k} + fiu_fp_lr_log{k}) ;
    fiu_recall_lr_log{k} = fiu_tp_lr_log{k} ./ (fiu_tp_lr_log{k} + fiu_fn_lr_log{k}) ;
    %%%
    
    %%% msr
    msr_prob_test_lr_log = mnrval( fiu_model_lr_log_k{k}  , msr_feature_test_log) ;
    msr_predict_test_lr_log_k{k} = (msr_prob_test_lr_log == max(msr_prob_test_lr_log,[],2)) * (1 : y)' ;
    
    score_home_lr_log = msr_prob_test_lr_log(:,1) - max(msr_prob_test_lr_log , [ ] , 2) ;
    [msr_fp_lr_log_k{k} , msr_tp_lr_log_k{k} , ~ , msr_auc_lr_log_k{k}] = perfcurve(msr_label_k_test(:,k) , score_home_lr_log , '1') ;
    
    if y > 2
        score_temp = msr_prob_test_lr_log(:,1) - max(msr_prob_test_lr_log(:,2:end),[],2) ;
        target = '1' ;
    else
        score_temp = msr_prob_test_lr_log(:,2) ;
        target = '0' ;
    end
    
    [~ , ~ , ~ , msr_auc_lr_log_k{k}] = perfcurve( msr_label_k_test(:,k) , score_temp , target) ;
    
    msr_accuracy_rate_lr_log_k{k} = sum(( msr_predict_test_lr_log_k{k} ==  msr_label_k_test(:,k))) / N_msr_test ;
    
    msr_confusion_lr_log = zeros(y) ;
    j_pred = 0 ;
    for i_pred = label_temp
        j_pred = j_pred + 1 ;
        j_test = 0 ;
        for i_test = label_temp
            j_test = j_test + 1 ;
            msr_confusion_lr_log(j_pred,j_test) = sum( (msr_predict_test_lr_log_k{k} == i_pred) & (msr_label_k_test(:,k)  == i_test) ) ;
        end
    end
    
    transfer = eye( y ) ~= 1 ;
    
    msr_tp_lr_log{k} = diag(msr_confusion_lr_log)' ;
    msr_fp_lr_log{k} = diag(msr_confusion_lr_log * transfer')' ;
    msr_fn_lr_log{k} = diag(msr_confusion_lr_log' * transfer)' ;
    
    msr_precision_lr_log{k} = msr_tp_lr_log{k} ./ (msr_tp_lr_log{k} + msr_fp_lr_log{k}) ;
    msr_recall_lr_log{k} = msr_tp_lr_log{k} ./ (msr_tp_lr_log{k} + msr_fn_lr_log{k}) ;
    %%%
    
end

%%

sum( [msr_label_test]==3 &  label_all(j_shuffle==3,1)==0 )
