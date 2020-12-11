close all,clear all,clc   

im1=imread('r3moiecc009.tif');
target=load('targetim5g3.txt');
im2 = mat2gray(im1);
figure, imshow(im1);
% im2=adapthisteq(im2a);
[m n]= size(im1);
m1 = round(m/2);
m2 = round(4*m);
im_cart =car2polar(im2,m1,m2);
figure
subplot(2,1,1);
imshow(im_cart)
hold on
line([200 200],[1 m1])
hold off
    
P=improfile(im_cart,[200 200],[1 m1])';
 y1=smooth(P,5,'moving');
 y2=smooth(y1,0.3,'loess');
 subplot(2,1,2);
 plot(P)
 hold on
 plot(y2,'r')
 hold off

G=10;
xaxis=round(G/2):m1-round(G/2)-1;
    for i=1:1:m1-G
        Ra(i)=sum(abs(P(i:G+i)-0.5))/G;
        Rq(i)=sqrt(sum((P(i:G+i)-0.5).^2)/G);
        Rku(i)=sum((P((i:G+i))-0.5).^4)/(G*Rq(i).^4);
        Rt(i) = max((P(i:G+i)-0.5))-min((P(i:G+i)-0.5));
        Rsk(i)=sum((P((i:G+i))-0.5).^3)/(G*Rq(i).^3);
    end
 figure,plot(P,'b--')
 hold on
 plot(xaxis,Ra,'r')
 title('Ra')
 hold off
  figure,plot(P,'b--')
 hold on
 plot(xaxis,Rq,'g')
  title('Rq')
  hold off
  figure,plot(P,'b--')
 hold on
 plot(xaxis,Rku,'c')
  title('Rku')
  hold off
  figure,plot(P,'b--')
 hold on
 plot(xaxis,Rt,'k')
  title('Rt')
  hold off
  figure,plot(P,'b--')
 hold on
 plot(xaxis,Rsk,'m')
  title('Rsk')
  hold off
  
%% Fuzzy set up
a=newfis('circularreal');

a=addvar(a,'input','Ra',[0.06 0.34]);
a=addmf(a,'input',1,'Low','pimf',[0.07 0.10 0.15 0.20]);
a=addmf(a,'input',1,'High','pimf',[0.16 0.19 0.28 0.32]);
 
a=addvar(a,'input','Rq',[0.07 0.36]);
a=addmf(a,'input',2,'Low','pimf',[0.09 0.11 0.16 0.22]);
a=addmf(a,'input',2,'High','pimf',[0.18 0.21 0.30 0.34]);

a=addvar(a,'input','Rt',[0.06 1]);
a=addmf(a,'input',3,'Low','pimf',[0.07 0.15 0.35 0.6]);
a=addmf(a,'input',3,'High','pimf',[0.4 0.5 0.8 0.9]);

% a=addvar(a,'input','Rsk',[-1.5 1.5]);
% a=addmf(a,'input',2,'Low','pimf',[-1.4 -1.2 -0.8 0]);
% a=addmf(a,'input',2,'High','pimf',[-0.9 0.1 1.4 1.8]);

a=addvar(a,'output','Fringe',[0 1]);
a=addmf(a,'output',1,'Not','gaussmf',[0.2 0]);
a=addmf(a,'output',1,'Yes','gaussmf',[0.2 1]);
ruleList=[ ...
1 1 1 2 1 1
2 2 2 1 1 1 ];
a=addrule(a,ruleList);
ruleedit(a);
ruleview(a);

%% Display Fuzzy System
% figure('name','Block diagram of the fuzzy system');
% plotfis(a);
% figure('name','Ra');
% plotmf(a,'input',1);
% % figure('name','Rq');
% % plotmf(a,'input',2);
% figure('name','Rt');
% plotmf(a,'input',2);
% figure('name','Rsk');
% plotmf(a,'input',3);
% figure('name','Fringe');
% plotmf(a,'output',1);
% ruleedit(a);
% ruleview(a);
resfringe=evalfis([Ra' Rq' Rt'],a);
num=size(resfringe);


error= resfringe-target;

figure, plot(xaxis,resfringe,'r')
hold on
plot(P,'b--')
plot(xaxis,target,'g')
hold off

[k l]=size(target);
correct= 0;
for i=1:k
if abs(error(i)) < 0.3
    correct=correct+1;
end
end
correct
recrate=correct/k*100
a=1;
b=(1/(2*5))*ones(1,2*5);
filtres = conv(b,resfringe);
[pks,locs] = findpeaks(filtres,'MinPeakHeight',0.7,'MinPeakDistance',10) 
figure, plot(filtres,'r')
hold on
plot(resfringe,'r')
plot(locs,pks,'x','MarkerSize',12)
hold off