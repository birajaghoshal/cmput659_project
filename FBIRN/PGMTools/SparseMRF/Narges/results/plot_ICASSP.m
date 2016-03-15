sp4_reg_FN = [0.94 0.87 0.05 0];
sp4_reg_FP = [0.006 0.01 0.1 0.2];

sp4_exp_FN = [0.7 0.66 0.1 0];
sp4_exp_FP = [0.05 0.05 0.1 0.24];

sp4_ban_FN = [0.995 0.995 0.9 0.84];
sp4_ban_FP = [0.0 0.00 0.01 0.02];

sp4_cv_FN = [0.17 0.03 0.0 0];
sp4_cv_FP = [0.3 0.53 0.98 0.99];

n=[30 50 500 1000];
figure(1);
plot(n,sp4_reg_FN,'ro-',n,sp4_exp_FN,'bx-',n,sp4_ban_FN,'k.-',n,sp4_cv_FN,'gv-','MarkerSize',8);
xlabel('N','FontSize', 16);
ylabel('False Negative Error','FontSize', 16);
legend('Flat Prior (Reg. Likelihood)','Exp. Prior','Theoretical', 'CV');
title('Random Networks, P=100, density=4%','FontSize', 16);

 figure(2);
plot(n,sp4_reg_FP,'ro-',n,sp4_exp_FP,'bx-',n,sp4_ban_FP,'k.-',n,sp4_cv_FP,'gv-','MarkerSize',8);
xlabel('N','FontSize', 16);
ylabel('False Positive Error','FontSize', 16);
legend('Flat Prior (Reg. Likelihood)','Exp. Prior','Theoretical', 'CV');
title('Random Networks, P=100, density=4%','FontSize', 16);

%%%%%% dense network

sp52_reg_FN = [0.992 0.98 0.56 0.3];
sp52_reg_FP = [0.01 0.03 0.2 0.38];

sp52_exp_FN = [0.87 0.87 0.54 0.3];
sp52_exp_FP = [0.12 0.12 0.29 0.4];

sp52_ban_FN = [0.9997 0.9999 0.98 0.97];
sp52_ban_FP = [0.0004 0.002 0.03 0.05];

sp52_cv_FN = [0.5 0.4 0.01 0.01];
sp52_cv_FP = [0.4 0.5 0.93 0.95];

n=[30 50 500 1000];
figure(11);
plot(n,sp52_reg_FN,'ro-',n,sp52_exp_FN,'bx-',n,sp52_ban_FN,'k.-',n,sp52_cv_FN,'gv-','MarkerSize',8);
xlabel('N','FontSize', 16);
ylabel('False Negative Error','FontSize', 16);
legend('Flat Prior (Reg. Likelihood)','Exp. Prior','Theoretical', 'CV');
title('Random Networks, P=100, density=52%','FontSize', 16);

 figure(12);
plot(n,sp52_reg_FP,'ro-',n,sp52_exp_FP,'bx-',n,sp52_ban_FP,'k.-',n,sp52_cv_FP,'gv-','MarkerSize',8);
xlabel('N','FontSize', 16);
ylabel('False Positive Error','FontSize', 16);
legend('Flat Prior (Reg. Likelihood) ','Exp. Prior','Theoretical', 'CV');
title('Random Networks, P=100, density=52%','FontSize', 16);


%%%%%% lambda evolution over N

sp4_reg = [190 210 55 27];
sp52_reg = [500 500 23 14];

sp4_exp = [34 51 63 26];
sp52_exp = [32 47 22 14];

sp4_ban = [621 664 2517 3401];
sp52_ban = [1120 2209 5438 7115];

sp4_cv = [2 1 0.1 0.1];
sp52_cv = [0.4 0.4 0.1 0.1];

n=[30 50 500 1000];
semilogy(n,sp4_reg,'ro-',n,sp4_exp,'bx-',n,sp4_ban,'k.-',n,sp4_cv,'gv-','MarkerSize',8);
xlabel('N','FontSize', 16);
ylabel('Lambda','FontSize', 16);
legend('Flat Prior (Reg. Likelihood)','Exp. Prior','Theoretical', 'CV');
title('Random Networks, P=100, density=4%','FontSize', 16);

 figure(22);
semilogy(n,sp52_reg,'ro-',n,sp52_exp,'bx-',n,sp52_ban,'k.-',n,sp52_cv,'gv-','MarkerSize',8);
xlabel('N','FontSize', 16);
ylabel('Lambda','FontSize', 16);
legend('Flat Prior (Reg. Likelihood) ','Exp. Prior','Theoretical', 'CV');
title('Random Networks, P=100, density=52%','FontSize', 16);

