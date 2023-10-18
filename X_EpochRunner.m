function epoch_results = X_EpochRunner(epoch_size,batch_size)

epoch_results = zeros(epoch_size,1);

num_batch = ceil(epoch_size/batch_size);

for i = 1:num_batch
    if (batch_size*i) > epoch_size
        input = BatchRunner(i*batch_size,(i*batch_size)-epoch_size);
        epoch_results( ((i-1)*batch_size)+1:((i*batch_size)-((i*batch_size)-epoch_size)) ) = input;
    else
        input = BatchRunner(i*batch_size,batch_size);
        epoch_results( ((i-1)*batch_size)+1:(i*batch_size) ) = input;
    end
end