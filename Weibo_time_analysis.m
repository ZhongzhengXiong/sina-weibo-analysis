M = csvread('WeiboTweets.csv');
year = M(:, 3).';
month = M(:, 4).';
day = M(:, 5).';
hour = M(:, 6).';

% 1��-31��ÿ��΢������
dayIndex = 1:31;
n = hist(day, dayIndex);
figure();
plot(dayIndex, n,  '-b.');
xlabel('��', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);

% ��һ--����ÿ��΢������
len = size(day, 2);
week = weekday(datenum(year, month, day) - 1);
weekIndex = 1:7;
n = hist(week, weekIndex);
figure();
plot(weekIndex, n, '-r+');
xlabel('����', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);
weekString = { '��һ', '�ܶ�', '����', '����', '����', '����', '����'};
ax = gca;
set(ax, 'XTick', weekIndex, 'XTickLabel', weekString, 'FontSize', 10);
ax.XTickLabelRotation = 45;

% 0ʱ-23ʱûСʱ΢������
hourIndex = 0:23;
n = hist(hour, hourIndex);
figure();
plot(hourIndex, n, '-g*');
xlabel('Сʱ', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', hourIndex);

