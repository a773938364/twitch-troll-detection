%rawMatrix = csvread('full_features-active.csv');
featureMatrix = rawMatrix(:,2:end);
fprintf('\t >>> Running on subset of full data <<<\n');

fprintf('Calculating Distance Matrix...\n');
tic
%distanceMatrix = calculateDistanceMatrix(featureMatrix);
toc
fprintf('Done!\n');

fprintf('Calculating DKNN k=500\n');
%dknn_scores500 = DKNN(500, distanceMatrix);
fprintf('Calculating DKNN k=50\n');
%dknn_scores50 = DKNN(50, distanceMatrix);
fprintf('Calculating DKNN k=5\n');
%dknn_scores5 = DKNN(5, distanceMatrix);
fprintf('Calculating DKNN k=1\n')
%dknn_scores1 = DKNN(1, distanceMatrix);

set(0,'DefaultAxesFontSize', 12);
set(0,'DefaultTextFontSize', 12);

ANOMALY_THRESHOLD = 40;
numUsers = length(dknn_scores1);
numberTrolls = zeros(1,4);
for i = 1:numUsers
    if dknn_scores1(1,i) > ANOMALY_THRESHOLD
        numberTrolls(1) = numberTrolls(1) + 1;
    end
    if dknn_scores5(1,i) > ANOMALY_THRESHOLD
        numberTrolls(2) = numberTrolls(2) + 1;
    end
    if dknn_scores50(1,i) > ANOMALY_THRESHOLD
        numberTrolls(3) = numberTrolls(3) + 1;
    end
    if dknn_scores500(1,i) > ANOMALY_THRESHOLD
        numberTrolls(4) = numberTrolls(4) + 1;
    end
end

numberTrolls = numberTrolls/numUsers;
bar(numberTrolls);
grid;
set(gca, 'YTickMode','auto');
set(gca, 'YTickLabel',num2str(100.*get(gca,'YTick')','%g%%'));
set(gca,'XTickLabel',{'k=1', 'k=5', 'k=50', 'k=500'})
ylabel('Percent of Points Labeled as Anomalies');
    
%{
[n4, xout4] = hist(dknn_scores1, 100);
b4 = bar(xout4,n4,'k');
grid;
hold on;

[n3, xout3] = hist(dknn_scores5, 100);
b3 = bar(xout3,n3,'b');

[n2, xout2] = hist(dknn_scores50, 100);
b2 = bar(xout2,n2,'g');

[n1, xout1] = hist(dknn_scores500, 100);
b1 = bar(xout1,n1,'r');

ah1 = gca;
ah2 = axes('position',get(gca,'position'), 'visible','off');
ah3 = axes('position',get(gca,'position'), 'visible','off');
ah4 = axes('position',get(gca,'position'), 'visible','off');
legend(ah1, b1, 'Location', [0.7 0.85 0.15 0.05], 'k=500')
legend(ah2, b2, 'Location', [0.7 0.75 0.15 0.05], 'k=50')
legend(ah3, b3, 'Location', [0.7 0.65 0.15 0.05], 'k=5')
legend(ah4, b4, 'Location', [0.7 0.55 0.15 0.05], 'k=1')
hold off
%}
