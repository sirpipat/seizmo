function [idep]=shortidep(idep)
%SHORTIDEP    Converts idep long description to a shorter one of just units
long={'Unknown' 'Displacement (nm)' 'Velocity (nm/sec)' ...
      'Acceleration (nm/sec^2)' 'Velocity (volts)' 'Absement (nm*sec)' ...
      'Absity (nm*sec^2)' 'Abseleration (nm*sec^3)' 'Abserk (nm*sec^4)' ...
      'Absnap (nm*sec^5)' 'Absackle (nm*sec^6)' 'Abspop (nm*sec^7)' ...
      'Jerk (nm/sec^3)' 'Snap (nm/sec^4)' 'Crackle (nm/sec^5)' ...
      'Pop (nm/sec^6)' 'Counts'};
short={'unknown' 'nm' 'nm/sec' 'nm/sec^2' 'volts' 'nm*sec' 'nm*sec^2' ...
       'nm*sec^3' 'nm*sec^4' 'nm*sec^5' 'nm*sec^6' 'nm*sec^7' ...
       'nm/sec^3' 'nm/sec^4' 'nm/sec^5' 'nm/sec^6' 'counts'};
[tf,i]=ismember(idep,long);
idep(~tf)={'unknown'};
idep(tf)=short(i(tf));
end
