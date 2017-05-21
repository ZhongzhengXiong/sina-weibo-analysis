% ��ʼ�������õ������ϣ�����csv�ļ���M��
provinces = {'����', '�㽭', 'ɽ��', '����', '�Ϻ�', '���', '����',... 
             '����', '�㶫', '����', 'ɽ��', '������', '�ӱ�', '����',...
             '����', '����', '̨��', '����', '�Ĵ�',  '����', '����', ...
             '����', '�½�', '����', '����', '����', '����', '����', ...
             '����', '���', '����', '����', '����', '����', '�ຣ',...
             '����'};
M = csvread('WeiboProfile.csv');

%�ֱ������ͬ�Ա�����֮�ͣ����Ʊ�״ͼ
genderSum = getSum(M, 2, 2);
figure();
pie(genderSum, {'��', 'Ů'});
title('�û��Ա�ֲ�');

% �ֱ������֤�ͷ���֤���������Ʊ�״ͼ
verifiedSum = getSum(M, 3, 2);
figure();
pie(verifiedSum, {'����֤', '����֤'});
title('�û���֤���');

% �����ͬʡ�ݵ�ע������������ֱ��ͼ
provinceSum = getSum(M, 7, 36);
figure();
x = 1:36;
bar(x, provinceSum);
for i = x
    text(x(i)-0.2, provinceSum(i)+5, num2str(provinceSum(i)));
end
xlabel('ʡ��', 'FontSize', 15);
ylabel('����', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', 1:36, 'XTickLabel', provinces, 'FontSize', 10);
set(ax, 'YLim', [0, 200]);
ax.XTickLabelRotation = 45;
title('�û������ֲ�');


% ͳ�Ʋ�ͬ��ݵ�����������ֱ��ͼ
figure();
x = 2008:2015;
n = hist(M(:,4).', x);
bar(x, n);
for i = 1:length(x)
    if n(i) > 0
       text(x(i), n(i)+10, num2str(n(i)));
    end
end
xlabel('���', 'FontSize', 15);
ylabel('����', 'FontSize', 15);
title('ע����ݷֲ�');

% ���ƹ�ע���ͷ�˿����ɢ��ͼ
follow = M(:, 8).';
follower = M(:, 9).';
figure();
plot(follow, follower, '.b');
xlabel('��ע��', 'FontSize', 15);
ylabel('����ע��', 'FontSize', 15);
title('�û���ע���뱻��ע����ϵ');


% �Ա����ע���Ĺ�ϵ
follow = M(:, 8).';
follow_gender = [];
follow_gender(1) = 0;
follow_gender(2) = 0;
for i = 1:length(follow)
    follow_gender(M(i, 2)+1) = follow_gender(M(i, 2)+1) + follow(i);
end
average_follow = follower_gender ./ genderSum;
pie(average_follow, {'����', 'Ů��'});
title('�Ա����ע�����Ĺ�ϵ');


% �Ա����˿������ϵ
follower = M(:, 9).';
follower_gender = [];
follower_gender(1) = 0;
follower_gender(2) = 0;
for i = 1:length(follower)
    follower_gender(M(i, 2)+1) = follower_gender(M(i, 2)+1) + follower(i);
end
average_follower = follower_gender ./ genderSum;
pie(average_follower, {'����', 'Ů��'});
title('�Ա����˿�����Ĺ�ϵ');

% ΢�������������˿�����Ĺ�ϵ
follower = M(:, 9).';
tweet_count = M(:,10).';
figure();
plot(follower, tweet_count, '.b');
xlabel('��˿����', 'FontSize', 15);
ylabel('����΢������', 'FontSize', 15);
title('΢�������������˿�����Ĺ�ϵ');
axis([0, 100, 0, 100]);

% ��ͬ����΢����������
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
xlabel('ʡ��', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);
ax = gca;
set(ax, 'XTick', 1:36, 'XTickLabel', provinces, 'FontSize', 10);
ax.XTickLabelRotation = 45;
title('��ͬ����΢����������');

% ��ͬ�Ա𷢲�΢������
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
xlabel('�Ա�', 'FontSize', 15);
ylabel('΢������', 'FontSize', 15);
ax = gca;
set(ax,  'XTickLabel', {'��', 'Ů'}, 'FontSize', 10);
title('��ͬ�Ա𷢲�΢������');

% ΢�������������ע��֮��Ĺ�ϵ
follow = M(:, 8).';
tweet_count = M(:,10).';
figure();
plot(follow, tweet_count, '.b');
xlabel('��ע����', 'FontSize', 15);
ylabel('����΢������', 'FontSize', 15);
title('΢�������������ע��֮��Ĺ�ϵ');
axis([0, 500, 0, 500]);



