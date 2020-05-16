%ugrad_train

clc
clear
close all

%arrange the data

Data=importdata('ugraddata.txt');
P=Data(:,[1,2,3]); %all the rows first three columns
T=Data(:,[4,5]); %all the rows last two columns

%to make assessments of the individual students
p=P';
t=T';

%check
[r,q]=size(p);
[s,qt]=size(t);
	if q ~=qt
		error('diffent batch sizes');
	end

%use mapminmax function here
%pn and tn are attained from this procedure
%

%training index
I1=randperm(floor(2*q/3));
q1=length(I1);

%test index
I2=setdiff([1:q],I1);
q2=length(I2);

%training set (using the indices get the actual training sets)
p1=p(:,I1);
t1=t(:,I1);

%normal the training set
p1n=pn(:,I1);
t1n=tn(:,I1);

%test set (using the indices get the actual training sets)
p1=p(:,I2);
t1=t(:,I2);

%normal the test set
p1n=pn(:,I2);
t1n=tn(:,I2);

%layer sizes
s1=9;
s2=9;
s3=s; %dimensions of the target

%to initialize the weights and the biases
W1=randu(-1,1,s1,r);
b1=randu(-1,1,s1,1);
W2=randu(-1,1,s2,r);
b2=randu(-1,1,s2,1);
W3=randu(-1,1,s3,r);
b3=randu(-1,1,s3,1);

%defining the transfer functions
%@ are the function handles
f1=@tansig;
f2=@logsig;
f3=@purelin;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Training parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%learning rate
h=.05;

%epoch counter
k=1;

%initialize error for epoch
mse=1;

%collect errors in EE
E(1)=mse % where E is the vector of MSE's

%set tolerance
tol=1e-8;
 
%max iterations
maxit=800; %burtons's recommendation after fiddling with his programme :)

%train on normalised data: p1n, t1n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	while mse>tol & k<maxit
		k=k+1;
		for j=1:q1
			%propagate input pattern through the net
			n1=W1*p1n(:,j)+b1;
			a1=f1(n1);
			n2=W2*a1+b2;
			a2=f2(n2);
			n3=W3*a2+b3;
			a3=f3(n3);
			an(:,j)=a3;
			
			%jth error vector
			e(:,j)=t1n(:,j)-an(:,j);
			
			%derivative matrices : remember backpropagation, it goes backwards
			D3=eye(s3);
			D2=diag((1-a2).*a2);
			D1=diag(1-a1.^2);
			
			%sensitivity vectors
			S3=-2*D3*e(:,j);
			S2=D2*W3'*S3;
			S1=D1*W2'*S2;
			
			%update weights and biases
			W3=W3-h*S3*a2';
			b3=b3-h*S3;
			W2=W2-h*S2*a1';
			b2=b2-h*S2;
			W1=W1-h*S1*p1n(:,j)';
			b1=b1-h*S1;
		end
		
		%error for epoch
		mse=sum(sum(e).^2)/q1;
		
		%accumulate MSE into the vector: EE
		E(k)=mse;
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if I want to see the sensitivities
ds=input('display sensitivities? 1=yes 0=no');
	if ds==1
		disp('The initial and final sensitivities are: ')
		SS(:,(1:10, end-10:end))
	end

%scale up
%make use of the mapmaxmin function to do this!

%R^22 statistic
r2=rsq(t1,a);

%corrcoeff
[R1,PV1]=corrcoeff(a(1,:),t1(1,:));
fprint("Training: Semester 1:\n\n");
fprint(' corr coeff: %g\n p value: %g\n r2: %g\n',R1(1,2),PV1(1,2),r2(1))
disp("---------------------------------------------------------------")

[R2,PV2]=corrcoeff(a(2,:),t1(2,:));
fprint("Training: Semester 2:\n\n");
fprint(' corr coeff: %g\n p value: %g\n r2: %g\n',R2(1,2),PV2(1,2),r2(2))
disp("---------------------------------------------------------------")

%Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t11=t1(1,:);
a11=a(1,:);

t12=t1(2,:);
a12=a(2,:);

%plot error (performance function)
close all

E=E(2:end);
plot(E);
title('MSE');

figure
hold on
plot(t11,t11);
plot(t11,a11,'*');
title(sprintf('Training: Semester 1 with %g samples\n',q));
hold off

figure
hold on
plot(t12,t12);
plot(t12,a12,'*');
title(sprintf('Training: Semester 2 with %g samples\n',q));
hold off

%save variables
save ugrad_train.mat

