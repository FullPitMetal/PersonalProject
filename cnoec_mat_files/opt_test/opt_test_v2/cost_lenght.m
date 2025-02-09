%cost_function
function cost = cost_lenght(x,x_in,x_out,y_in,y_out)

N_points = length(x_in);

for ind = 1 : N_points-1 
x_in_kp1= x_in(ind+1);
x_in_k = x_in(ind);
x_out_kp1=x_out(ind+1);
x_out_k = x_out(ind);

y_in_kp1= y_in(ind+1);
y_in_k = y_in(ind);
y_out_kp1=y_out(ind+1);
y_out_k = y_out(ind);


f1 = (x_in_kp1+ x(ind+1)*(x_out_kp1- x_in_kp1)-(x_in_k+ x(ind)*(x_out_k-x_in_k)))^2;
f2 = (y_in_kp1+ x(ind+1)*(y_in_kp1-y_out_kp1)-(y_in_k+ x(ind)*(y_out_k-y_in_k)))^2;

%}

cost = f1 + f2;
%beta = 0.3;
%gamma = 1000;
%cost = cost + gamma * exp(beta*(x(ind))) + gamma* exp(beta*(x(ind)-1));

end

end
%+0.6 * exp(-0.3*(x(ind))) + 0.6* exp(0.3*(x(ind)-1));