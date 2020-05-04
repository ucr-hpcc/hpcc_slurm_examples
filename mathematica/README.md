# Activation
You will have to setup the mathematica license via a License server named "mathlm".

1. Configure [X-Forward](https://hpcc.ucr.edu/manuals_linux-basics_intro.html#how-to-get-access) or [VNC](https://hpcc.ucr.edu/manuals_linux-cluster_jobs.html#desktop-environments) method.
2. Log back into the cluster (with X-Forwarding or via VNC) and run mathematica:

```
module load mathematica
mathematica
```

2. Do not use license file or key, but rather click on the bottom button `Other ways to activate`.
3. Then click the option `Connect to a license server`.
4. After that you should enter the name "mathlm" in the field and click `activate`.

