P = csvread('WeiboProfile.csv');
T = csvread('WeiboTweets.csv');
id = P(:, 1).';
userNum = size(id, 2);
idmap = containers.Map(id, 1:userNum);

tweetsId = T(:, 1).';
tweetsSize = size(tweetsId, 2);
year = T(:, 3).';
month = T(:, 4).';
day = T(:, 5).';
hour = T(:, 6).';
weekDay = weekday(datenum(year, month, day) - 1); 
weekNum = weeknum(datenum(year, month, day));

Date = [T(:, 3:6) weekDay.' tweetsId.'];
Date = sortrows(Date, [1, 2, 3, 4]);


tweetsNum = zeros(1, userNum);
userDay = zeros(userNum, 4);
userMonth = zeros(userNum, 3);
userWeek = zeros(userNum, 3);
userHour = zeros(userNum, 4);
userWeekday = zeros(userNum, 7);
userWeekdayNum = zeros(userNum, 7);

% 用户微博总量
for i = 1:tweetsSize
    tweetsNum(idmap(tweetsId(i))) = tweetsNum(idmap(tweetsId(i))) + 1;
end


% 日均微博量
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:3), userDay(userid, 1:3))
         userWeekday(userid, Date(i, 5)) = userWeekday(userid, Date(i, 5)) + 1;
         userDay(userid, 1:3) = Date(i, 1:3);
         userDay(userid, 4) = userDay(userid, 4) + 1;
    end
end
averageDay = tweetsNum ./ userDay(:, 4).'; 

% 一周平均每日微博量
for i = 1:tweetsSize
    userid = idmap(tweetsId(i));
    userWeekdayNum(userid, weekDay(i)) = userWeekdayNum(userid, weekDay(i)) + 1;
end
averageWeekday = userWeekdayNum ./ userWeekday;
averageWeekday(isnan(averageWeekday) == 1) = 0;


% 周均微博量
Date_week = [T(:, 3) weekNum.' tweetsId.'];
Date_week = sortrows(Date_week, [1, 2]);
for i = 1:tweetsSize
    userid = idmap(Date_week(i, end));
    if ~isequal(Date_week(i, 1:2), userWeek(userid, 1:2)) 
         userWeek(userid, 1:2) = Date(i, 1:2);
         userWeek(userid, 3) = userWeek(userid, 3) + 1;
    end
end
averageWeek = tweetsNum ./ userWeek(:, 3).';


% 月均微博量
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:2), userMonth(userid, 1:2))
         userMonth(userid, 1:2) = Date(i, 1:2);
         userMonth(userid, 3) = userMonth(userid, 3) + 1;
    end
end
averageMonth = tweetsNum ./ userMonth(:, 3).';


% 不同时间段发表量
% [9:12):  [12:18): 下午 [18, 22): 夜晚 [22, 9) 其他
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    tempHour = Date(i, 4);
    if tempHour >= 9 && tempHour < 12
        category = 1;
    elseif tempHour >= 12 && tempHour < 18
        category = 2;
    elseif tempHour >= 18 && tempHour < 22
        category = 3;
    else
        category = 4;
    end
    userHour(userid, category) = userHour(userid, category) + 1;  
end


% kmeans聚类分析
X = [tweetsNum.', averageDay.', averageWeek.', averageMonth.', userHour, averageWeekday];

k = 10;
% [IDX, C] = kmeansplusplus(X.', k);
% IDX = IDX.';
IDX = kmeansplusplus(X.', k);
IDX = IDX.';
clusterUsernum = hist(IDX, 1:k);
clusterBound = zeros(1, k);
clusterBound(1) = clusterUsernum(1);
for i = 2:k
    clusterBound(i) = clusterUsernum(i) + clusterBound(i-1);
end
clusterBound = [0  clusterBound];
IDX = [IDX (1:userNum).'];

% 绘出每一类的日发布量每周图
IDX_weekday = [IDX (userWeekdayNum./repmat(tweetsNum.', 1,7))];
IDX_weekday = sortrows(IDX_weekday, [1, 2]);
for i = 1:k
    clusterMatrix = IDX_weekday(clusterBound(i)+1:clusterBound(i+1), :);
    figure(); 
    hold on;
    plot(clusterMatrix(:,2).', clusterMatrix(:,3).', '-g.');
    plot(clusterMatrix(:,2).', clusterMatrix(:,4).', '-m.');
    plot(clusterMatrix(:,2).', clusterMatrix(:,5).', '-b.');
    plot(clusterMatrix(:,2).', clusterMatrix(:,6).', '-c.');
    plot(clusterMatrix(:,2).', clusterMatrix(:,7).', '-y.');
    plot(clusterMatrix(:,2).', clusterMatrix(:,8).', '-r.');
    plot(clusterMatrix(:,2).', clusterMatrix(:,9).', '-k.');
end

