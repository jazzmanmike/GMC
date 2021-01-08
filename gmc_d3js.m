%% Simple script for parsing eLogbook data to d3js for visualisation

%load data
load('~/gmc_data.xls');

%set variables

Department = unique(Department);
nUnits = length(Department);
nOutcomes = length(unique(Outcome));

Score(isnan(Score)) = 0;

fid = fopen('gmc_d3js','w');
counter = 0;
for iUnit = 1:nUnits
    fprintf(fid, '[//%s\n', Department{iUnit});
    for iOutcome = 1:nOutcomes
        fprintf(fid, '{axis:"%s",value:%g},\n', Outcome{iOutcome}, (Score(counter + iOutcome)./100));
    end
    fprintf(fid, '],');
    counter = counter + nOutcomes;
end

for iOutcome = 1:nOutcomes
    outcome_max(iOutcome) = max(Score(iOutcome:nOutcomes:end));
    outcome_min(iOutcome) = min(Score(iOutcome:nOutcomes:end));
    outcome_avg(iOutcome) = mean(Score(iOutcome:nOutcomes:end));
end

summary_variables = [CUH' outcome_max outcome_min outcome_avg];
summary_variables_list = {'CUH', 'max_score', 'min_score', 'average_score'};

fid = fopen('gmc_summary_d3js','w');
counter = 0;
for i = 1:length(summary_variables_list)
    fprintf(fid, 'var %s = [ \n', summary_variables_list{i});
    for iOutcome = 1:nOutcomes
        fprintf(fid, '{x:"%s",value:%g},\n', Outcome{iOutcome}, (summary_variables(counter + iOutcome)));
    end
    fprintf(fid, ']; \n');
    counter = counter + nOutcomes;
end


