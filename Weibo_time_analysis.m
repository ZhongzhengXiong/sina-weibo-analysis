M = csvread('WeiboTweets.csv');
year = M(:, 3).';
month = M(:, 4).';
day = M(:, 5).';
hour = M(:, 6).';

% tweet monthly
dayIndex = 1:31;
n = hist(day, dayIndex);
figure();
plot(dayIndex, n, '-b.');
xlabel('��', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);


% tweet weekly
len = size(day, 2);
week = zeros(1, len);
for i = 1:len
    week(i) = weekday(datestr([year(i), month(i), day(i), 0, 0, 0]));
end
weekIndex = 1:7;
n = hist(week, weekIndex);
figure();
plot(weekIndex, n, '-r+');
xlabel('����', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);
weekString = {'����', '��һ', '�ܶ�', '����', '����', '����', '����'};
ax = gca;
set(ax, 'XTick', weekIndex, 'XTickLabel', weekString, 'FontSize', 10);
ax.XTickLabelRotation = 45;


% tweet daily
hourIndex = 0:23;
n = hist(hour, hourIndex);
figure();
plot(hourIndex, n, '-g*');
xlabel('Сʱ', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', hourIndex);

