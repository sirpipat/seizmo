function [data]=doubleit(data)
%DOUBLEIT    Change in memory SAClab data storage to double precision
%
%    Description: Changes the data in memory to double precision.  This
%     does not affect the storage type or version for files written from 
%     the data (that requires changing the header version).
%
%    Usage: data=doubleit(data)
%
%    Examples:
%     Double the precision of records and fix the delta intervals
%      data=fixdelta(doubleit(data))
%
%    See also: combo, distro, fixdelta

% check nargin
error(nargchk(1,1,nargin))

% check data structure
if(~isfield(data,'x'))
    error('data structure does not have proper fields')
end

% number of records
nrecs=length(data);

% retreive header info
leven=glgc(data,'leven');

% add zeros and update header
for i=1:nrecs
    % double header and data
    data(i).head=double(data(i).head);
    data(i).x=double(data(i).x);
    
    % double time
    if(~strcmp(leven(i),'true')); data(i).t=double(data(i).t); end
end

end

