function [x,J_vals,E_vals,runtimes] = APG(x_init,F,dF,R,proxR,gamma,n_iters,opts)
% initialization
x = x_init;
z = x;
J_vals = NaN(n_iters+1,1);
E_vals = NaN(n_iters+1,1);
runtimes = NaN(n_iters,1);

J_vals(1) = F(x)+R(x);
if isa(opts.errfunc,'function_handle')
    E_vals(1) = opts.errfunc(z);
end

timer = tic;
for iter = 1:n_iters
    
    % gradient projection update
    x_next = proxR(z - gamma*dF(z),gamma);
    J_vals(iter+1) = F(x) + R(x);
    z = x_next + (iter/(iter+3))*(x_next - x);
    
    % record runtime
    runtimes(iter) = toc(timer);
    
    % calculate error metric
    if isa(opts.errfunc,'function_handle')
        E_vals(iter+1) = opts.errfunc(z);
    end
    
    % display status
    if opts.verbose
        fprintf('iter: %4d | objective: %10.4e | stepsize: %2.2e | runtime: %5.1f s\n', ...
                iter, J_vals(iter+1), gamma, runtimes(iter));

    end
    
    x = x_next;

    this_x = rot90(x,2);
    figure(2023);imshow([mat2gray(abs(this_x)),mat2gray(angle(this_x))],[])
end

end

