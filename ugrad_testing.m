%ugrad_test
clc
clear
close all

%load trained net
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load ugrad_train.mat
clear a an

%simulate on p2n t2n
	for j=1:q2
		n1=W1*p2n(:,j)+b1;
		a1=f1(n1);
		n2=W2*a1+b2;
		a2=f2(n2);
		n3=W3*a2+b3;
		a3=f3(n3);
		an(:,j)=a3;
	end
%scale up
%make use of the mapmaxmin function to do this!

%R^22 statistic
r2=rsq(t2,a);

%corrcoeff
[R1,PV1]=corrcoeff(a(1,:),t2(1,:));
fprint("Testing: Semester 1:\n\n");
fprint(' corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2(1))
disp("---------------------------------------------------------------")

[R2,PV2]=corrcoeff(a(2,:),t2(2,:));
fprint("Testing: Semester 2:\n\n");
fprint(' corr coeff: %g\n p value: %g\n r2: %g\n',R2(1,2),PV2(1,2),r2(2))
disp("---------------------------------------------------------------")

%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t21=t2(1,:);
a21=a(1,:);

t22=t2(2,:);
a22=a(2,:);

%plot error (performance function)
close all

E=E(2:end);
plot(E);
title('MSE');

figure
hold on
plot(t21,t21);
plot(t21,a21,'*');
title(sprintf('Testing: Semester 1 with %g samples\n',q));
hold off

figure
hold on
plot(t22,t22);
plot(t22,a22,'*');
title(sprintf('Testing: Semester 2 with %g samples\n',q));
hold off
