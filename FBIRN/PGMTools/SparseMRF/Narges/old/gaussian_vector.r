# the code for the synthetic data, averaging over 30 matrices with vector, gaussian prior
#setwd("C:\\Tools\\MyMatlabTools\\SparseMRF\\Narges")

library(MASS)
library(glasso)


## Initialization: 
file_name<-"results_gaussian_vector_structured.txt"
#seed_r<-c(12,32,42,52,62,72,82,92,102,100,200,300,500,555,546,745,999,597,97,99,888,832,732,777,735,733,723,713,703,603)
N_vector<- c(30,50,500,1000)
vv<-1

ss<-100

for(vv in 1 : 4){

lambda_avg<-0
P_avg<-0
FP_avg<-0
TP_avg<-0


runs<-1;

for(runs in 1:30){
name<-paste("net",runs,".txt", sep="")
A1 <- matrix(scan(name, 0), ncol=ss, byrow=TRUE)


Sig=solve(A1)




mtest<-100;

x_test<-mvrnorm(mtest, mu= c(rep(0,ss) ), Sig )

dd<-N_vector[vv];
data<-mvrnorm(dd,rep(0,ss),Sig)
x<-matrix(data,ncol=ss)
s<- var(x)

eps<-0.001
Sinv<-solve(s + eps*diag(1,ss)) ##solve(s,tol = 10^(-22))
b<-rep(0,ss)
for(i in 1:ss){
b[i]<-ss/sum(abs(Sinv[i,]))
}

#b<-b*2*(ss/dd)

A1_nnz<-0
for(i in 1:ss)
for(j in 1:ss)
if(A1[i,j]!=0) A1_nnz<-A1_nnz+1
print(A1_nnz)

N<-dd
m<-1# number of iterations
obj_opt<-matrix(rep(0,m))
obj_lambda_opt<-matrix(rep(0,m*ss),ncol=ss)
obj_cov_opt<-matrix(rep(0,ss*ss*m) ,ncol=ss*ss)
obj_iteration<-matrix(rep(0,m))
obj_nnz<-matrix(rep(0,m))
obj_trace<-matrix(rep(0,m*5000),ncol=5000)


for(kk in 1:m){
	print("******************************ITERATION: ******************** ")
	print(kk)
	done<-0
	objective<--10000000
	objective_last<--10000000
	lambda<- rep(kk*5, ss)
	last_lambda<-rep(kk*5,ss) 
	new_lambda<-rep(kk*5,ss) 
	it<-0


### SEARCH:	
while(done==0){
	it<-it+1
	objective_last<-objective
	a<-glasso(s, rho=(2/N) *lambda  ,thr=1.0e-3,penalize.diagonal=TRUE)
	norm1<-matrix(rep(0,ss))
	for (i in 1:ss){
		for(j in 1:ss){
			norm1[i]<-norm1[i]+ abs(a$wi[i,j])
		}
	}
	mm<-0
	for(i in 1:dd){
		mm<-mm+( x[i,] %*% a$wi %*% x[i,] )
	}

	ll<-0
	for(j in 1:ss){
		ll<-ll + ss*log(lambda[j]/2)- lambda[j] * norm1[j] - 0.5*(lambda[j]-b[j])^2
	}

	objective<-  - 0.5 * mm + dd * 0.5 * log ( det(a$wi)  )  + ll
	if( (objective > objective_last) || it==1){
		print("good") 
		print(it)
		for(i in 1:ss){
			bb<- norm1[i]  -b[i]
			new_lambda[i]<- 0.5*( -bb + sqrt(bb^2 + 4*ss) ) 		
		}
	}
	else{
		print(" **************************backtrachking **************************************")
		alpha<-1  
		while(objective < objective_last && alpha>0.001){	      
			##print(alpha)
			for(i in 1:ss){
				new_lambda[i]<-last_lambda[i] + alpha * (new_lambda[i] - last_lambda[i])    ##( (ss*ss/last_lambda) - norm11 )		
			}
			alpha<-alpha/2;
			a<-glasso(s, rho=(2/N) *new_lambda ,thr=1.0e-3 ,penalize.diagonal=TRUE)
			norm1<-matrix(rep(0,ss))
			for (i in 1:ss){
				for(j in 1:ss){
					norm1[i]<-norm1[i]+ abs(a$wi[i,j])
				}	
			}
			mm<-0
			for(i in 1:dd){
				mm<-mm+( x[i,] %*% a$wi %*% x[i,] )
			}
			ll<-0
			for(j in 1:ss){
				ll<-ll + ss*log(new_lambda[j]/2)- new_lambda[j] * norm1[j] - 0.5*(new_lambda[j]-b[j])^2


			}
			objective<-  - 0.5 * mm + dd * 0.5 * log ( det(a$wi)  )  + ll
		}
	}
	last_lambda<-lambda
	lambda<-new_lambda
	obj_trace[kk,it]<-objective
	if( objective - objective_last  < 0.01){
		 done<-1
	}
	
	print("objective:")
	print(objective)
}


	for (g in 1:ss){
		for(gg in 1:ss){
			if(a$wi[g,gg]!=0) obj_nnz[kk]<-obj_nnz[kk]+1
		}
	}
	obj_opt[kk]<-objective
	for(g in 1:ss){
		obj_lambda_opt[kk,g]<-lambda[g]
	}
	obj_cov_opt[kk,]<-a$wi
	obj_iteration[kk]<- it
}




A1_nnz<-0
for(i in 1:ss)
for(j in 1:ss)
if(A1[i,j]!=0) A1_nnz<-A1_nnz+1
 A1_nnz

 nnz<-0
p2<-ss*ss
 for(i in 1:p2){
##for(j in 1:ss)
if(abs(obj_cov_opt[m,i])>0.0){ nnz<-nnz+1}
}
 nnz


fp<-0
for(i in 1:ss)
for(j in 1:ss)
if(A1[i,j]==0 && obj_cov_opt[m,(i-1)*ss+j]!=0) fp<-fp+1

fp


tp<-nnz-fp
tp<- (tp-ss) / (A1_nnz - ss)

fp<- fp / (ss*ss - A1_nnz)




lse<-0
error<-0
n<-ss
for(f in 1:n){
	sigma12<-matrix(rep(0,n-1), nrow=1)
	sigma22<- matrix(rep(0,(n-1)*(n-1) ), nrow=n-1, ncol= n-1)

	sigma12<-a$w[f,-f]; ## the covariance of variable f with the rest of variables
	sigma22<-a$w[-f,-f];
	sigma22inv<-solve(sigma22)
	sigma12<-as.matrix(sigma12, nrow=n-1, ncol=1)
	sigma22inv<-as.matrix(sigma22inv, nrow=n-1, ncol=n-1)
	y_1<-matrix(rep(0,(n-1)*(n-1)), nrow=n-1, ncol=n-1)
	y_test<-0
	for (i in 1:mtest){
		xval<-as.matrix(t(x_test[i,-f]), nrow=n-1, ncol=1)
		y1<-t(sigma12) %*% sigma22inv
		y_test<- y1 %*% t(xval)
		error = error + ( y_test - x_test [i,f] )^2
	}
}
lse<-error/ (mtest * n)


lambda_avg<-lambda_avg + obj_lambda_opt

P_avg<-P_avg + lse

TP_avg<- TP_avg + tp

FP_avg<- FP_avg + fp




### write the results in the file:


 write("----------------------------------------------------------",file_name,append=TRUE)
 write("P=100, Gaussian Prior,  no normalization of the data  ",file_name,append=TRUE)

 write("N= ",file_name,append=TRUE)

 write(dd,file_name,append=TRUE)

 write("b= ",file_name,append=TRUE)

 write(b,file_name,append=TRUE)

 write("learned lambda",file_name,append=TRUE)
 write(obj_lambda_opt,file_name,append=TRUE)

 write("Prediction Mean Squared Error of the learned model ",file_name,append=TRUE)
 write(lse,file_name,append=TRUE)

write("TP of the learned C ",file_name,append=TRUE)
 write(tp,file_name,append=TRUE)

write("FP of the learned C ",file_name,append=TRUE)
 write(fp,file_name,append=TRUE)


}




write("----------------------------------------------------------",file_name,append=TRUE)

 write("lambda_avg",file_name,append=TRUE)
 write(lambda_avg/runs,file_name,append=TRUE)
 
 write("lse_avg",file_name,append=TRUE)
 write(P_avg/runs,file_name,append=TRUE)

 write("TP_avg",file_name,append=TRUE)
 write(TP_avg/runs,file_name,append=TRUE)

 write("FP_avg",file_name,append=TRUE)
 write(FP_avg/runs,file_name,append=TRUE)



}























































































