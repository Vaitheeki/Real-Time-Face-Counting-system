function [ log ] = makelog( type,msg )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
log = 0;
    logFile = fullfile(pwd, 'log_details.log');
    if ~exist(logFile, 'file')
    H1 = 'This is Logfile for Mathlab Sofware';
    A0 = 'Log File Created: ';
    A1 = datetime('now');
    A2 = type;
    B1='-';
    A3 = msg;
    formatSpec1 = '%s \r\n %s  %s \r\n';
    formatSpec2 = '%s %s %s \r\n';
    fileID = fopen('log_details.log','w');
    fprintf(fileID,formatSpec1,H1,A0,A1);
    fprintf(fileID,formatSpec2,A1,A2,B1,A3);
    fclose(fileID);
    log = 1;
    else 
    A1 = datetime('now');
    A2 = type;
    A3 = msg;
    formatSpec = '%s %s %s \r\n';
    fileID = fopen('log_details.log','a+');
    fprintf(fileID,formatSpec,A1,A2,A3);
    fclose(fileID);
    log = 1;
    end
    if log == 1
        disp('Your Message has been Logged');
    else
        disp('Unable to save Log Message');
    end


end

