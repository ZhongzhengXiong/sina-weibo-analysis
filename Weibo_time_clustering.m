% 本脚本文件是基于用户使用微博的时间习惯对用户进行聚类分析
% 使用到的用户的微博使用时间相关特征包括: 用户微博总量， 日均微博量， 一周日均微博量（周一至周日), 周均微博量，
% 月均微博量，一天四个时间段平均微博量。 共计15维数据
% （上述微博量，包括原创和转发）
% 使用的聚类方法是k-means++聚类方法，具体代码在kmeansplusplus.m文件中
% 利用Matlab自带的evalcluster()方法确定聚类数K
% 最终生成的聚类结果存储在clusterResult矩阵中


% 分别读取两个csv文件，存入P和T中
P = csvread('WeiboProfile.csv');
T = csvread('WeiboTweets.csv');

% 将用户id离散化，便于后续数据操作
% 使用Map方法, 将用户id和用户数量映射，离散化到1-usernum这个空间
id = P(:, 1).';
userNum = size(id, 2);
idmap = containers.Map(id, 1:userNum);

% tweetsId: 每条微博对应的id
% tweetsSize: 微博的总数
% tweetsYear: 微博发表在第几年
% tweetsMonth: 微博发表在第几月
% tweetsDay: 微博发表在第几天
% tweetsWeekday: 微博发表在周几
% tweetsWeeknum: 微博发表在第几周
tweetsId = T(:, 1).';
tweetsSize = size(tweetsId, 2);
tweetsYear = T(:, 3).';
tweetsMonth = T(:, 4).';
tweetsDay = T(:, 5).';
tweetsWeekday = weekday(datenum(tweetsYear, tweetsMonth, tweetsDay) - 1); 
tweetsWeeknum = weeknum(datenum(tweetsYear, tweetsMonth, tweetsDay));

% 包含每条微博的年，月，日，时，工作日，对应用户id
% 利用sortrows方法，将日期排序
Date = [T(:, 3:6) tweetsWeekday.' tweetsId.'];
Date = sortrows(Date, [1, 2, 3, 4]);

% usertweetsNum: 用户微博总量
% userDay：用户使用微博总的天数， 该矩阵最后一列用于存储总天数，前三列用于后续相同日期的计算
% userMonth: 用户使用微博的月数， 该矩阵最后一列用于存储总月数，前两列用于后续相同月份的计算
% userWeek: 用户使用微博的周数， 该矩阵最后一列用于存储总周数，前两列用于后续相同周数的计算
% userHour: 用户四个时间段使用微博的数目--[9:12)  [12:18)  [18, 22) [22, 9)
% userWeekday: 用户使用微博的每个工作日的总数 (e.g. n个周一， m个周二...)
% userWeekdayNum： 用户一周每天使用微博的总数 (周一-周日)
% 初始化，预分配内存
usertweetsNum = zeros(1, userNum);
userDay = zeros(userNum, 4);
userMonth = zeros(userNum, 3);
userWeek = zeros(userNum, 3);
userHour = zeros(userNum, 4);
userWeekday = zeros(userNum, 7);
userWeekdayNum = zeros(userNum, 7);


% 用户微博总量计算
for i = 1:tweetsSize
    usertweetsNum(idmap(tweetsId(i))) = usertweetsNum(idmap(tweetsId(i))) + 1;
end


% 日均微博量计算
% 计算发微博的总的天数， 相同日期只计算一次
% Date日期已经排序，按顺序读取date,获取date对应的用户id,
% 比较该date与userDay中记录的最近一次date（前三列数据），不相同则更新该用户使用微博天数（第四列数据）
% 日均微博量计算 = 总微博数 / 总天数
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:3), userDay(userid, 1:3))
         userWeekday(userid, Date(i, 5)) = userWeekday(userid, Date(i, 5)) + 1;
         userDay(userid, 1:3) = Date(i, 1:3);
         userDay(userid, 4) = userDay(userid, 4) + 1;
    end
end
averageDayNum = usertweetsNum ./ userDay(:, 4).'; 

% 一周平均每日微博量计算
% 首先计算userWeekday, 即用户使用微博的每个工作日的总数(e.g. n个周一， m个周二...)，计算方法同日均微博量计算方法
% 其次计算userWeekdayNum, 即用户一周每天使用微博的总数 (周一-周日)，计算方法同上
% averageWeekdayNum(一周平均每日微博量计算) = userWeekdayNum ./ userWeekday
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:3), userDay(userid, 1:3))
         userWeekday(userid, Date(i, 5)) = userWeekday(userid, Date(i, 5)) + 1;
    end
end
for i = 1:tweetsSize
    userid = idmap(tweetsId(i));
    userWeekdayNum(userid, tweetsWeekday(i)) = userWeekdayNum(userid, tweetsWeekday(i)) + 1;
end
averageWeekdayNum = userWeekdayNum ./ userWeekday;
averageWeekdayNum(isnan(averageWeekdayNum) == 1) = 0; %将结果中的NAN设为0


% 周均微博量
% 首先计算使用微博的总的周数，相同周仅计算一次，计算方法同日均微博量计算方法
% userWeek的前两列数据用于存储最近一次的周数，用于相同周的比较
% 相同周判定为同一年同一周，格式“年-周”，用Date_week存储该格式数据
% averageWeekNum =  usertweetsNum ./ userWeek(:, 3).'
Date_week = [T(:, 3) tweetsWeeknum.' tweetsId.'];
Date_week = sortrows(Date_week, [1, 2]);
for i = 1:tweetsSize
    userid = idmap(Date_week(i, end));
    if ~isequal(Date_week(i, 1:2), userWeek(userid, 1:2)) 
         userWeek(userid, 1:2) = Date(i, 1:2);
         userWeek(userid, 3) = userWeek(userid, 3) + 1;
    end
end
averageWeekNum = usertweetsNum ./ userWeek(:, 3).';


% 月均微博量
% 首先计算使用微博的总的月数，相同月数计算一次，计算方法同同日均微博量计算方法
% userMonth的前两列数据用于存储最近一次的月份，用于相同月份的比较
% averageMonth = usertweetsNum ./ userMonth(:, 3).';
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:2), userMonth(userid, 1:2))
         userMonth(userid, 1:2) = Date(i, 1:2);
         userMonth(userid, 3) = userMonth(userid, 3) + 1;
    end
end
averageMonthNum = usertweetsNum ./ userMonth(:, 3).';


% 不同时间段发表量
% [9:12):早上 [12:18):下午 [18, 22):夜晚 [22, 9) 其他
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
% Feature为最终的特征向量，总的维度15维
% 为了提高kmeans聚类的准确度和效率,首先通过evalcluster()方法确定k值，然后用kmeans++方法对数据进行聚类
% 最终聚类的结果存储在clusterResult矩阵中
Feature = [usertweetsNum.', averageDayNum.', averageWeekNum.', averageMonthNum.', userHour, averageWeekdayNum];
E = evalclusters(Feature,'kmeans','CalinskiHarabasz','klist',1:5);
E = addK(E,6:10);
k = E.OptimalK;
clusterResult = kmeansplusplus(Feature.', k);
clusterResult = clusterResult.';
