# MongoDB

## Configure

First load the module:

```bash
module load mongo/4.2.0
```

Create and move to data location:

```bash
mkdir -p ~/bigdata/mongo/data
cd ~/bigdata/mongo
```

You can run mongo simply like this, however there were numa node warnings:

```bash
singularity run -B data:/data/db $MONGO_IMG
```

Run mongo the first time with numa node support and without auth:

```bash
singularity instance start -B data:/data/db $MONGO_IMG numactl --interleave=all mongod
```

From the same terminal, connect to your mongodb service like so:
```bash
singularity exec -B data:/data/db $MONGO_IMG mongo
```

Then create an admin user with the following:
```
use admin
db.createUser(
  {
    user: 'admin',
    pwd: passwordPrompt(),
    roles: [ { role: 'root', db: 'admin' } ]
  }
);
```

For more information regarding user access, please refer to the following:
[https://docs.mongodb.com/manual/tutorial/enable-authentication/#create-the-user-administrator](https://docs.mongodb.com/manual/tutorial/enable-authentication/#create-the-user-administrator)

Then stop mongod service:

```bash
singularity instance stop numactl
```

## Within the same job

You can now start it again from within a job, like so:

```bash
module load mongo
cd ~/bigdata/mongo
singularity instance start -B data:/data/db $MONGO_IMG numactl --interleave=all mongod --auth
```

>> NOTE: This does not seem to be working within the latest version of mongo.

## Separate Jobs

Or as a separate job like this:

```
sbatch -p short --wrap 'module load mongo; cd ~/bigdata/mongo; singularity exec -B data:/data/db $MONGO_IMG numactl --interleave=all mongod --bind_ip_all --auth;'
```

Lastly connect to mongod service, from the same job, with the following:

```bash
singularity exec -B data:/data/db $MONGO_IMG mongo --authenticationDatabase "admin" -u "admin" -p
```

Or connnect to mongod from a different node like so:

```bash
singularity exec -B data:/data/db $MONGO_IMG mongo --host NodeName --authenticationDatabase "admin" -u "admin" -p
```

