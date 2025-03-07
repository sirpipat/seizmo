function [report]=check_cmb_results(results)
%CHECK_CMB_RESULTS    Validates a core-diffracted wave analysis struct
%
%    Usage:    msg=check_cmb_results(results)
%
%    Description:
%     MSG=CHECK_CMB_RESULTS(RESULTS) verifies that the variable RESULTS is
%     a valid core-diffracted wave analysis results struct.  If the input
%     variable fails certain requirements an appropriate error message
%     structure is returned as MSG.  The RESULTS struct is expected to have
%     the following fields:
%      .runname         - name of this run, used for naming output
%      .dirname         - directory containing the waveforms
%      .phase           - core-diffracted wave type
%      .synthetics      - TRUE if synthetic data (only reflect synthetics)
%      .earthmodel      - synthetic earth model ('DATA' if not synthetics)
%      .filter          - filter parameters
%      .usersnr         - snr parameters & snr
%      .tt_start        - starting relative arrival times
%      .useralign       - arrival time, polarity, amplitude solution info
%      .corrections     - travel time & amplitude corrections
%      .usercluster     - clustering info
%      .outliers        - outlier info
%      .time            - time of struct creation as a string
%     RESULTS is generated by CMB_1ST_PASS and is taken as input for
%     CMB_2ND_PASS, CMB_OUTLIERS, CMB_CLUSTERING, SLOWDECAYPAIRS, &
%     SLOWDECAYPROFILES.  
%
%    Notes:
%     - This also checks that RESULTS is internally consistent.
%
%    Examples:
%     % This is how to use this:
%     error(check_cmb_results(results));
%
%    See also: CMB_1ST_PASS, CMB_2ND_PASS, CMB_OUTLIERS, CMB_CLUSTERING,
%              SLOWDECAYPAIRS, SLOWDECAYPROFILES

%     Version History:
%        Jan. 15, 2011 - initial version
%        Jan. 18, 2011 - require .time field
%        Jan. 26, 2011 - require .synthetics & .earthmodel
%        Mar. 11, 2013 - commented out advanced clustering
%        Jan. 27, 2014 - abs path fix for isdir test for .dirname field
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Jan. 27, 2014 at 13:35 GMT
%
% Last modified by sirawich-at-princeton.edu: 03/02/2023

% todo:

% check results
report=[];
reqfields={'useralign' 'filter' 'initwin' 'usersnr' 'userwinnow' ...
    'corrections' 'outliers' 'tt_start' 'phase' 'runname' 'dirname' ...
    'usercluster' 'time' 'synthetics' 'earthmodel'};
if(~isstruct(results))
    report.identifier='seizmo:check_cmb_results:badInput';
    report.message='RESULTS must be a struct!';
    return;
elseif(any(~isfield(results,reqfields)))
    report.identifier='seizmo:cmb_cmb_results:badInput';
    report.message=...
        ['RESULTS must be a struct with the fields: ' ...
        sprintf('''%s'' ',reqfields{:}) '!'];
    return;
else
    validphase={'Pdiff' 'SHdiff' 'SVdiff'};
    for a=1:numel(results)
        % skip if empty
        if(isempty(results(a).useralign)); continue; end
        
        % number of records
        if(~isfield(results(a).useralign,'data') ...
                || ~isseizmo(results(a).useralign.data,'dep'))
            report.identifier='seizmo:cmb_cmb_results:badData';
            report.message='RESULTS.useralign.data is broken!';
            return;
        end
        nrecs=numel(results(a).useralign.data);
        
        % check xc
        if(~isfield(results(a).useralign,'xc') ...
                || ~isfield(results(a).useralign.xc,'cg') ...
                || ~isreal(results(a).useralign.xc.cg) ...
                || size(results(a).useralign.xc.cg,1)~=(nrecs^2-nrecs)/2)
            report.identifier='seizmo:cmb_cmb_results:badXC';
            report.message='RESULTS.useralign.xc.cg is broken!';
            return;
        end
        
        % check solution
        if(~isfield(results(a).useralign,'solution') ...
                || ~isfield(results(a).useralign.solution,'arr') ...
                || ~isfield(results(a).useralign.solution,'arrerr') ...
                || ~isfield(results(a).useralign.solution,'amp') ...
                || ~isfield(results(a).useralign.solution,'amperr') ...
                || ~isfield(results(a).useralign.solution,'pol') ...
                || numel(results(a).useralign.solution.arr)~=nrecs ...
                || numel(results(a).useralign.solution.arrerr)~=nrecs ...
                || numel(results(a).useralign.solution.amp)~=nrecs ...
                || numel(results(a).useralign.solution.amperr)~=nrecs ...
                || numel(results(a).useralign.solution.pol)~=nrecs ...
                || ~isreal(results(a).useralign.solution.arr) ...
                || ~isreal(results(a).useralign.solution.arrerr) ...
                || ~isreal(results(a).useralign.solution.amp) ...
                || ~isreal(results(a).useralign.solution.amperr) ...
                || ~isreal(results(a).useralign.solution.pol))
            report.identifier='seizmo:cmb_cmb_results:badSolution';
            report.message='RESULTS.useralign.solution is broken!';
            return;
        end
        
        % check filter
        if(~isfield(results(a).filter,'corners') ...
                || numel(results(a).filter.corners)~=2 ...
                || ~isreal(results(a).filter.corners) ...
                || any(results(a).filter.corners)<=0 ...
                || results(a).filter.corners(1)...
                >=results(a).filter.corners(2))
            report.identifier='seizmo:cmb_cmb_results:badFilter';
            report.message='RESULTS.filter appears corrupted!';
            return;
        end
        
        % check snr
        if(~isfield(results(a).usersnr,'snrcut') ...
                || ~isfield(results(a).usersnr,'snr') ...
                || ~isscalar(results(a).usersnr.snrcut) ...
                || ~isreal(results(a).usersnr.snrcut) ...
                || ~isreal(results(a).usersnr.snr) ...
                || sum(results(a).usersnr.snr>=...
                results(a).usersnr.snrcut)<nrecs)
            report.identifier='seizmo:cmb_cmb_results:badSNR';
            report.message='RESULTS.usersnr appears corrupted!';
            return;
        end
        
        % check phase
        if(~isstring1d(results(a).phase) ...
                || ~any(strcmp(results(a).phase,validphase)))
            report.identifier='seizmo:cmb_cmb_results:badPhase';
            report.message='RESULTS.phase must be Pdiff, SHdiff, or SVdiff';
            return;
        end
        
        % check runname
        if(~isstring1d(results(a).runname))
            report.identifier='seizmo:cmb_cmb_results:badRunName';
            report.message='RESULTS.runname must be a string!';
            return;
        end
        
        % check dirname
        if(~isstring1d(results(a).dirname))
            
        end
        if(~isabspath(results(a).dirname))
            results(a).dirname=[pwd filesep results(a).dirname];
        end
        if(~isdir(results(a).dirname))
            report.identifier='seizmo:cmb_cmb_results:badDirName';
            report.message='RESULTS.dirname must be a valid directory!';
            return;
        end
        
        % check corrections
        m3d=['hmsl06' lower(results(a).phase(1))];
        if(~isfield(results(a).corrections,'ellcor') ...
                || ~isfield(results(a).corrections,'crucor') ...
                || ~isfield(results(a).corrections,'mancor') ...
                || ~isfield(results(a).corrections,'geomsprcor') ...
                || ~isfield(results(a).corrections.crucor,'prem') ...
                || ~isfield(results(a).corrections.mancor,m3d) ...
                || ~isfield(results(a).corrections.mancor.(m3d),'full') ...
                || ~isfield(results(a).corrections.mancor.(m3d),'upswing') ...
                || numel(results(a).corrections.ellcor)~=nrecs ...
                || numel(results(a).corrections.crucor.prem)~=nrecs ...
                || numel(results(a).corrections.mancor.(m3d).full)~=nrecs ...
                || numel(results(a).corrections.mancor.(m3d).upswing)~=nrecs ...
                || numel(results(a).corrections.geomsprcor)~=nrecs ...
                || ~isreal(results(a).corrections.ellcor) ...
                || ~isreal(results(a).corrections.crucor.prem) ...
                || ~isreal(results(a).corrections.mancor.(m3d).full) ...
                || ~isreal(results(a).corrections.mancor.(m3d).upswing) ...
                || ~isreal(results(a).corrections.geomsprcor))
            report.identifier='seizmo:cmb_cmb_results:badCorrections';
            report.message='RESULTS.corrections appears corrupted!';
            return;
        end
        
        % check outliers
        if(~isfield(results(a).outliers,'bad') ...
                || ~islogical(results(a).outliers.bad) ...
                || numel(results(a).outliers.bad)~=nrecs)
            report.identifier='seizmo:cmb_cmb_results:badOutliers';
            report.message='RESULTS.outliers appears corrupted!';
            return;
        end
        
        % check clusters
        if(~isfield(results(a).usercluster,'T') ...
                || ~isfield(results(a).usercluster,'good') ...
                ... %|| ~isfield(results(a).usercluster,'units') ...
                || ~isfield(results(a).usercluster,'color') ...
                || numel(results(a).usercluster.T)~=nrecs ...
                ... %|| numel(results(a).usercluster.units)~=nrecs ...
                || ~isequal(size(results(a).usercluster.color),...
                [max(results(a).usercluster.T) 3]) ...
                || numel(results(a).usercluster.good)...
                ~=max(results(a).usercluster.T))
            report.identifier='seizmo:cmb_cmb_results:badClusters';
            report.message='RESULTS.usercluster appears corrupted!';
            return;
        end
        
        % check time
        if(~isstring1d(results(a).time))
            report.identifier='seizmo:cmb_cmb_results:badTime';
            report.message='RESULTS.time must be a string!';
            return;
        end
        
        % check synthetics
        if(~isscalar(results(a).synthetics) ...
                || ~islogical(results(a).synthetics))
            report.identifier='seizmo:cmb_cmb_results:badSynFlag';
            report.message='RESULTS.synthetics must be TRUE/FALSE!';
            return;
        end
        
        % check earthmodel
        if(~isstring1d(results(a).time))
            report.identifier='seizmo:cmb_cmb_results:badMODEL';
            report.message='RESULTS.earthmodel must be a string!';
            return;
        end
    end
end

end
