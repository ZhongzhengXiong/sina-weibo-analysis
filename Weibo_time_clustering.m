% ���ű��ļ��ǻ����û�ʹ��΢����ʱ��ϰ�߶��û����о������
% ʹ�õ����û���΢��ʹ��ʱ�������������: �û�΢�������� �վ�΢������ һ���վ�΢��������һ������), �ܾ�΢������
% �¾�΢������һ���ĸ�ʱ���ƽ��΢������ ����15ά����
% ������΢����������ԭ����ת����
% ʹ�õľ��෽����k-means++���෽�������������kmeansplusplus.m�ļ���
% ����Matlab�Դ���evalcluster()����ȷ��������K
% �������ɵľ������洢��clusterResult������


% �ֱ��ȡ����csv�ļ�������P��T��
P = csvread('WeiboProfile.csv');
T = csvread('WeiboTweets.csv');

% ���û�id��ɢ�������ں������ݲ���
% ʹ��Map����, ���û�id���û�����ӳ�䣬��ɢ����1-usernum����ռ�
id = P(:, 1).';
userNum = size(id, 2);
idmap = containers.Map(id, 1:userNum);

% tweetsId: ÿ��΢����Ӧ��id
% tweetsSize: ΢��������
% tweetsYear: ΢�������ڵڼ���
% tweetsMonth: ΢�������ڵڼ���
% tweetsDay: ΢�������ڵڼ���
% tweetsWeekday: ΢���������ܼ�
% tweetsWeeknum: ΢�������ڵڼ���
tweetsId = T(:, 1).';
tweetsSize = size(tweetsId, 2);
tweetsYear = T(:, 3).';
tweetsMonth = T(:, 4).';
tweetsDay = T(:, 5).';
tweetsWeekday = weekday(datenum(tweetsYear, tweetsMonth, tweetsDay) - 1); 
tweetsWeeknum = weeknum(datenum(tweetsYear, tweetsMonth, tweetsDay));

% ����ÿ��΢�����꣬�£��գ�ʱ�������գ���Ӧ�û�id
% ����sortrows����������������
Date = [T(:, 3:6) tweetsWeekday.' tweetsId.'];
Date = sortrows(Date, [1, 2, 3, 4]);

% usertweetsNum: �û�΢������
% userDay���û�ʹ��΢���ܵ������� �þ������һ�����ڴ洢��������ǰ�������ں�����ͬ���ڵļ���
% userMonth: �û�ʹ��΢���������� �þ������һ�����ڴ洢��������ǰ�������ں�����ͬ�·ݵļ���
% userWeek: �û�ʹ��΢���������� �þ������һ�����ڴ洢��������ǰ�������ں�����ͬ�����ļ���
% userHour: �û��ĸ�ʱ���ʹ��΢������Ŀ--[9:12)  [12:18)  [18, 22) [22, 9)
% userWeekday: �û�ʹ��΢����ÿ�������յ����� (e.g. n����һ�� m���ܶ�...)
% userWeekdayNum�� �û�һ��ÿ��ʹ��΢�������� (��һ-����)
% ��ʼ����Ԥ�����ڴ�
usertweetsNum = zeros(1, userNum);
userDay = zeros(userNum, 4);
userMonth = zeros(userNum, 3);
userWeek = zeros(userNum, 3);
userHour = zeros(userNum, 4);
userWeekday = zeros(userNum, 7);
userWeekdayNum = zeros(userNum, 7);


% �û�΢����������
for i = 1:tweetsSize
    usertweetsNum(idmap(tweetsId(i))) = usertweetsNum(idmap(tweetsId(i))) + 1;
end


% �վ�΢��������
% ���㷢΢�����ܵ������� ��ͬ����ֻ����һ��
% Date�����Ѿ����򣬰�˳���ȡdate,��ȡdate��Ӧ���û�id,
% �Ƚϸ�date��userDay�м�¼�����һ��date��ǰ�������ݣ�������ͬ����¸��û�ʹ��΢�����������������ݣ�
% �վ�΢�������� = ��΢���� / ������
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:3), userDay(userid, 1:3))
         userWeekday(userid, Date(i, 5)) = userWeekday(userid, Date(i, 5)) + 1;
         userDay(userid, 1:3) = Date(i, 1:3);
         userDay(userid, 4) = userDay(userid, 4) + 1;
    end
end
averageDayNum = usertweetsNum ./ userDay(:, 4).'; 

% һ��ƽ��ÿ��΢��������
% ���ȼ���userWeekday, ���û�ʹ��΢����ÿ�������յ�����(e.g. n����һ�� m���ܶ�...)�����㷽��ͬ�վ�΢�������㷽��
% ��μ���userWeekdayNum, ���û�һ��ÿ��ʹ��΢�������� (��һ-����)�����㷽��ͬ��
% averageWeekdayNum(һ��ƽ��ÿ��΢��������) = userWeekdayNum ./ userWeekday
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
averageWeekdayNum(isnan(averageWeekdayNum) == 1) = 0; %������е�NAN��Ϊ0


% �ܾ�΢����
% ���ȼ���ʹ��΢�����ܵ���������ͬ�ܽ�����һ�Σ����㷽��ͬ�վ�΢�������㷽��
% userWeek��ǰ�����������ڴ洢���һ�ε�������������ͬ�ܵıȽ�
% ��ͬ���ж�Ϊͬһ��ͬһ�ܣ���ʽ����-�ܡ�����Date_week�洢�ø�ʽ����
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


% �¾�΢����
% ���ȼ���ʹ��΢�����ܵ���������ͬ��������һ�Σ����㷽��ͬͬ�վ�΢�������㷽��
% userMonth��ǰ�����������ڴ洢���һ�ε��·ݣ�������ͬ�·ݵıȽ�
% averageMonth = usertweetsNum ./ userMonth(:, 3).';
for i = 1:tweetsSize
    userid = idmap(Date(i, end));
    if ~isequal(Date(i, 1:2), userMonth(userid, 1:2))
         userMonth(userid, 1:2) = Date(i, 1:2);
         userMonth(userid, 3) = userMonth(userid, 3) + 1;
    end
end
averageMonthNum = usertweetsNum ./ userMonth(:, 3).';


% ��ͬʱ��η�����
% [9:12):���� [12:18):���� [18, 22):ҹ�� [22, 9) ����
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


% kmeans�������
% FeatureΪ���յ������������ܵ�ά��15ά
% Ϊ�����kmeans�����׼ȷ�Ⱥ�Ч��,����ͨ��evalcluster()����ȷ��kֵ��Ȼ����kmeans++���������ݽ��о���
% ���վ���Ľ���洢��clusterResult������
Feature = [usertweetsNum.', averageDayNum.', averageWeekNum.', averageMonthNum.', userHour, averageWeekdayNum];
E = evalclusters(Feature,'kmeans','CalinskiHarabasz','klist',1:5);
E = addK(E,6:10);
k = E.OptimalK;
clusterResult = kmeansplusplus(Feature.', k);
clusterResult = clusterResult.';
