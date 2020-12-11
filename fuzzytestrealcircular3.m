close all,clear all,clc
im1=imread('r3moiecc001.tif');
target=load('targetim1g3.txt');
im2 = mat2gray(im1);
im3=adapthisteq(im2);

figure,imshow(im3)
hold on
[x,y] = ginput(2);
xline = [x(1), x(2)];
yline = [y(1), y(2)];
line( [x(1) x(2)],[y(1) y(2)]);
hold off
P1=improfile(im3,xline, yline);
P=P1';
[m n]= size(P);

G=10;
xaxis=round(G/2):n-round(G/2)-1;
    for i=1:1:n-G
        Ra(i)=sum(abs(P(i:G+i)-0.5))/G;
        Rq(i)=sqrt(sum((P(i:G+i)-0.5).^2)/G);
        Rt(i) = max((P(i:G+i)-0.5))-min((P(i:G+i)-0.5));
    end

  
%% Fuzzy set up
a=newfis('circularreal');

a=addvar(a,'input','Ra',[0.06 0.170]);
a=addmf(a,'input',1,'Low','pimf',[0.065 0.085 0.18 0.21]);
a=addmf(a,'input',1,'High','pimf',[0.19 0.35 0.45 0.5]);
 
a=addvar(a,'input','Rq',[0.07 0.5]);
a=addmf(a,'input',2,'Low','pimf',[0.09 0.095 0.23 0.26]);
a=addmf(a,'input',2,'High','pimf',[0.23 0.35 0.40 0.45]);

a=addvar(a,'input','Rt',[0.2 1.2]);
a=addmf(a,'input',3,'Low','pimf',[0.2 0.3 0.6 0.7]);
a=addmf(a,'input',3,'High','pimf',[0.5 0.8 0.9 1.1]);

a=addvar(a,'output','Fringe',[0 1]);
a=addmf(a,'output',1,'Not','gaussmf',[0.2 0]);
a=addmf(a,'output',1,'Yes','gaussmf',[0.2 1]);
ruleList=[ ...
1 1 1 2 1 1
2 2 2 1 1 1 ];
a=addrule(a,ruleList);

%% Display Fuzzy System

resfringe=evalfis([Ra' Rq' Rt'],a);
num=size(resfringe);
figure, plot(xaxis,resfringe,'r')
hold on
plot(P,'b--')
hold off

