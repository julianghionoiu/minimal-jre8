# minimal-jre8

Scripts for minimising a jre and deploying to an S3 bucket


### Prepare the original archives

Original JRE archives downloaded from https://installbuilder.bitrock.com/java/ and stored in an S3 bucket as Zip files.


### Document the unnecessary files

Use the Oracle guide to identify files that can be removed
https://www.oracle.com/technetwork/java/javase/jre-8-readme-2095710.html

The exclude rules are stored in:
```txt
config
    linux
        excludes.txt
        expected_size.txt
    macos
        excludes.txt
        expected_size.txt
    windows
        excludes.txt
        expected_size.txt
```

### Minimise the JRE for the target platform

```
./minimise_jre.sh macos
```
the JRE will be created into the `./build/` folder


### Test the JRE by unpacking and running Java

```
./run_jre.sh ./build/<JRE>
```