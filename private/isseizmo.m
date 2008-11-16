function [lgc]=isseizmo(data,varargin)
%ISSEIZMO    True for SEIZMO data structures
%
%    Description: ISSEIZMO(DATA) returns logical true if DATA is a SEIZMO 
%     data structure and false otherwise.  See SEIZMOCHECK for minimum 
%     requirements.
%
%     ISSEIZMO(DATA,FIELD1,...,FIELDN) allows adding more fields to the 
%     SEIZMO data structure requirements - see SEIZMOCHECK for details.
%
%    Notes:
%     - ISSEIZMO is just a logical frontend for SEIZMOCHECK
%
%    Tested on: Matlab r2007b
%
%    Usage:    logical=isseizmo(data)
%              logical=isseizmo(data,field1,...,fieldN)
%
%    Examples:
%     To see if the function READHEADER returns a valid SEIZMO structure
%     after reading in files from the current directory:
%
%       if(isseizmo(readheader('*'))); disp('Valid Structure'); end
%
%    See also: seizmocheck, seizmodef

%     Version History:
%        Feb. 28, 2008 - initial version
%        Mar.  4, 2008 - doc update
%        June 12, 2008 - doc update
%        Sep. 14, 2008 - doc update, input checks
%        Nov. 13, 2008 - renamed from ISSEIS to ISSEIZ
%        Nov. 15, 2008 - update for new name schema (now ISSEIZMO)
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Nov. 15, 2008 at 19:25 GMT

% todo:

% check input
if(nargin<1)
    error('seizmo:isseiz:notEnoughInputs','Not enough input arguments.');
elseif(nargin>1)
    for i=1:nargin-1
        if(~ischar(varargin{i}))
            error('seizmo:isseiz:badInput',...
                'Additional argument FIELD%d must be a string!',i);
        end
    end
end

% test output of seizmocheck call
lgc=isempty(seizmocheck(data,varargin{:}));

end
