function [who]=star69s(n)
%STAR69S    Returns who called the current function
%
%    Usage:  caller=star69s
%            caller=star69s(gen)
%
%    Description:
%     CALLER=STAR69S returns the caller of the function that has called this
%     function.  That is, it returns the grandparent of STAR69S.  So if FUN1
%     calls FUN2 and FUN2 uses STAR69S, STAR69S will return FUN1.  If there
%     is no calling function (as in it was directly called from the command
%     line) then CALLER is set to ''.
%
%     CALLER=STAR69S(GEN) specifies which caller generation to return.  The
%     default is 1 (parent).  A value of 0 will return the current function
%     and a value of 2 will return the grandparent (if it exists).
%
%    Notes:
%
%    Examples:
%     % grandparent (2 generations up) of current function
%     star69s(2)
%
%    See also: DBSTACK, MFILENAME

%     Version History:
%        Aug. 14, 2010 - initial version
%        Mar.  7, 2023 - changed function named from star69 to star69s
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Mar. 7, 2023 at 22:30 GMT by sirawich-at-princeton.edu

% todo:

% check nargin
error(nargchk(0,1,nargin));

% default/check generation
if(nargin<1 || isempty(n)); n=1; end
if(~isreal(n) || ~isscalar(n) || n~=fix(n))
    error('seizmo:star69s:badInput',...
        'GEN must be a scalar integer!');
end
n=n+2;

% get calling stack
% 1 is star69s
% 2 is star69s's caller
% 3 is star69s's caller's caller (default)
callers=dbstack;

% get caller
if(n<1 || n>numel(callers))
    who='';
else
    who=callers(n).name;
end

end
