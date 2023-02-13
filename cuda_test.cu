#include <stdio.h>
#include <cuda_runtime.h>

__global__ void addArrays(int *a, int *b, int *c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
        c[i] = a[i] + b[i];
}

int main() {
    const int n = 10;
    int a[n], b[n], c[n];

    // Initialize input arrays
    for (int i = 0; i < n; i++) {
        a[i] = i;
        b[i] = i * 2;
    }

    int *d_a, *d_b, *d_c;
    cudaMalloc((void **) &d_a, n * sizeof(int));
    cudaMalloc((void **) &d_b, n * sizeof(int));
    cudaMalloc((void **) &d_c, n * sizeof(int));

    cudaMemcpy(d_a, a, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, n * sizeof(int), cudaMemcpyHostToDevice);

    // Launch the kernel
    addArrays<<<1, n>>>(d_a, d_b, d_c, n);

    cudaMemcpy(c, d_c, n * sizeof(int), cudaMemcpyDeviceToHost);

    // Print the result
    for (int i = 0; i < n; i++)
        printf("%d + %d = %d\n", a[i], b[i], c[i]);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}