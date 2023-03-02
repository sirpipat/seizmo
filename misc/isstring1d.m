function [lgc]=isstring1d(str)
%ISSTRING1D    True for a string (row vector) of characters
%
%    Usage:    lgc=isstring1d(str)
%
%    Description:
%     LGC=ISSTRING1D(STR) returns TRUE if STR is a string (ie row vector) of
%     characters.  This means ISCHAR(STR) must be TRUE and SIZE(STR,1)==1.
%
%    Notes:
%
%    Examples:
%     % A 2x2 character array will return FALSE:
%     isstring1d(repmat('a',2,2))
%
%    See also: ISCHAR
%
%     Version History:
%        Sep. 13, 2010 - initial version (added docs)
%        Oct. 11, 2010 - allow empty string
%        Mar.  2, 2023 - renamed this function from issting to isstring1d
%                        to avoid name collision with the MATLAB
%                        built-in function
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Oct. 11, 2010 at 11:00 GMT
%
% Last modified by sirawich-at-princeton.edu: 03/02/2023

lgc=ischar(str) && ndims(str==2) ...
    && (size(str,1)==1 || isequal(size(str),[0 0]));

end
