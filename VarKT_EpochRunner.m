function epoch_results = VarKT_EpochRunner(epoch_size,batch_size)

epoch_results = zeros(epoch_size,1);

num_batch = ceil(epoch_size/batch_size);

INFO.PixelSpacing = [0.51; 0.51] ;  %[0.51; 0.51] MIDAS; [0.47; 0.47] IMPERIAL

% kT Default
kT = 0.3134*mean(INFO.PixelSpacing')^-1.522;

for i = 1:num_batch
    if (batch_size*i) > epoch_size
        input = BatchRunnerVar((i-1)*batch_size+1,(i*batch_size)-epoch_size,kT)
        epoch_results( ((i-1)*batch_size)+1:((i*batch_size)-((i*batch_size)-epoch_size)) ) = input;
    else
        input = BatchRunnerVar((i-1)*batch_size+1,batch_size,kT)
        epoch_results( ((i-1)*batch_size)+1:(i*batch_size) ) = input;
    end
end