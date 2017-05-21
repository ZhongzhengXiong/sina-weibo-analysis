% 初始化，设置地区集合，读入csv文件到M中
provinces = {'其他', '浙江', '山西', '江西', '上海', '天津', '福建',... 
             '辽宁', '广东', '北京', '山东', '黑龙江', '河北', '安徽',...
             '江苏', '海南', '台湾', '湖南', '四川',  '陕西', '吉林', ...
             '河南', '新疆', '湖北', '广西', '海外', '重庆', '内蒙', ...
             '甘肃', '香港', '澳门', '贵州', '云南', '西藏', '青海',...
             '宁夏'};
M = csvread('WeiboProfile.csv');

%分别求出不同性别人数之和，绘制饼状图
genderSum = getSum(M, 2, 2);
figure();
pie(genderSum, {'男', '女'});
title('用户性别分布');

% 分别求出验证和非验证人数，绘制饼状图
verifiedSum = getSum(M, 3, 2);
figure();
pie(verifiedSum, {'已验证', '无验证'});
title('用户验证情况');

% 求出不同省份的注册人数，绘制直方图
provinceSum = getSum(M, 7, 36);
figure();
x = 1:36;
bar(x, provinceSum);
for i = x
    text(x(i)-0.2, provinceSum(i)+5, num2str(provinceSum(i)));
end
xlabel('省份', 'FontSize', 15);
ylabel('人数', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', 1:36, 'XTickLabel', provinces, 'FontSize', 10);
set(ax, 'YLim', [0, 200]);
ax.XTickLabelRotation = 45;
title('用户地区分布');


% 统计不同年份的人数，绘制直方图
figure();
x = 2008:2015;
n = hist(M(:,4).', x);
bar(x, n);
for i = 1:length(x)
    if n(i) > 0
       text(x(i), n(i)+10, num2str(n(i)));
    end
end
xlabel('年份', 'FontSize', 15);
ylabel('人数', 'FontSize', 15);
title('注册年份分布');

% 绘制关注数和粉丝数的散点图
follow = M(:, 8).';
follower = M(:, 9).';
figure();
plot(follow, follower, '.b');
xlabel('关注数', 'FontSize', 15);
ylabel('被关注数', 'FontSize', 15);
title('用户关注数与被关注数关系');


% 性别与关注数的关系
follow = M(:, 8).';
follow_gender = [];
follow_gender(1) = 0;
follow_gender(2) = 0;
for i = 1:length(follow)
    follow_gender(M(i, 2)+1) = follow_gender(M(i, 2)+1) + follow(i);
end
average_follow = follower_gender ./ genderSum;
pie(average_follow, {'男性', '女性'});
title('性别与关注数量的关系');


% 性别与粉丝数量关系
follower = M(:, 9).';
follower_gender = [];
follower_gender(1) = 0;
follower_gender(2) = 0;
for i = 1:length(follower)
    follower_gender(M(i, 2)+1) = follower_gender(M(i, 2)+1) + follower(i);
end
average_follower = follower_gender ./ genderSum;
pie(average_follower, {'男性', '女性'});
title('性别与粉丝数量的关系');

% 微博发布数量与粉丝数量的关系
follower = M(:, 9).';
tweet_count = M(:,10).';
figure();
plot(follower, tweet_count, '.b');
xlabel('粉丝数量', 'FontSize', 15);
ylabel('发布微博数量', 'FontSize', 15);
title('微博发布数量与粉丝数量的关系');
axis([0, 100, 0, 100]);

% 不同地区微博发布数量
tweet_count = M(:,10).';
tweet_count_province = [];
for i = 1:36
    tweet_count_province(i) = 0;
end
for i = 1:length(tweet_count)
    tweet_count_province(M(i, 7)) = tweet_count_province(M(i, 7)) + tweet_count(i);
end
average_count = tweet_count_province ./ provinceSum;
x = 1:36;
bar(x, average_count);
for i = x
    text(x(i)-0.3, average_count(i)+5, num2str(int16(average_count(i))));
end
xlabel('省份', 'FontSize', 15);
ylabel('微博数量', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', 1:36, 'XTickLabel', provinces, 'FontSize', 10);
ax.XTickLabelRotation = 45;
title('不同地区微博发布数量');

% 不同性别发布微博数量
tweet_count = M(:,10).';
tweet_count_gender = [];
tweet_count_gender(1) = 0;
tweet_count_gender(2) = 0;
for i = 1:length(tweet_count)
    tweet_count_gender(M(i, 2)+1) = tweet_count_gender(M(i, 2)+1) + tweet_count(i);
end
average_count = tweet_count_gender ./ genderSum;
x = 1:2;
bar(x, average_count, 0.5);
for i = x
    text(x(i), average_count(i)+5, num2str(int16(average_count(i))));
end
xlabel('性别', 'FontSize', 15);
ylabel('微博数量', 'FontSize', 15);
ax = gca;
set(ax,  'XTickLabel', {'男', '女'}, 'FontSize', 10);
title('不同性别发布微博数量');

% 微博发布数量与关注数之间的关系
follow = M(:, 8).';
tweet_count = M(:,10).';
figure();
plot(follow, tweet_count, '.b');
xlabel('关注数量', 'FontSize', 15);
ylabel('发布微博数量', 'FontSize', 15);
title('微博发布数量与关注数之间的关系');
axis([0, 500, 0, 500]);



