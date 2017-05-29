M = csvread('WeiboTweets.csv');
year = M(:, 3).';
month = M(:, 4).';
day = M(:, 5).';
hour = M(:, 6).';

% 1号-31号每天微博数量
dayIndex = 1:31;
n = hist(day, dayIndex);
figure();
plot(dayIndex, n,  '-b.');
xlabel('日', 'FontSize', 15);
ylabel('微博数量', 'FontSize', 15);

% 周一--周日每天微博数量
len = size(day, 2);
week = weekday(datenum(year, month, day) - 1);
weekIndex = 1:7;
n = hist(week, weekIndex);
figure();
plot(weekIndex, n, '-r+');
xlabel('星期', 'FontSize', 15);
ylabel('微博数量', 'FontSize', 15);
weekString = { '周一', '周二', '周三', '周四', '周五', '周六', '周日'};
ax = gca;
set(ax, 'XTick', weekIndex, 'XTickLabel', weekString, 'FontSize', 10);
ax.XTickLabelRotation = 45;

% 0时-23时没小时微博数量
hourIndex = 0:23;
n = hist(hour, hourIndex);
figure();
plot(hourIndex, n, '-g*');
xlabel('小时', 'FontSize', 15);
ylabel('微博数量', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', hourIndex);

