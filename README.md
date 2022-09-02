[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-c66648af7eb3fe8bc4f294546bfd86ef473780cde1dea487d3c4ff354943c9ae.svg)](https://classroom.github.com/online_ide?assignment_repo_id=8310499&assignment_repo_type=AssignmentRepo)

# EMLO V2 - Session 01

## 01 - Docker

<br/>

### NOTE TO SELF:

1. Used multistaged build to reduce caching and build files clutter by only copying required dependencies after install to the production docker.

2. Even python slim image contains debian distro and files which takes upto 80MB more. Hence, only using distroless python image for production.

3. Pytorch file size too large. using specific whl package helps. Also using only required hardware version reduces jank. ( in this case only x86_64 cpu version is used).

4. pip install also caches jank worth 90 MB in this cache. Using `--no-cache-dir` helps.

- remove containers 

    ```
        docker container prune
    ```

- remove images 

    ```
        docker rmi $(docker images -a -q)
    ``` 

- run serverless distro

    ```
        docker run --entrypoint=sh -it <IMAGE_NAME>
    ```

## Run

- Pull image 

    ```
        docker pull emlo-assignment-1
    ```

- Using docker run 

    ```
        docker run $CONTAINER_NAME --model $MODEL_NAME --image $IMAGE_NAME
    ```

- To run from inside docker:

    ```
        docker run --entrypoint=sh -it emlo_assignment_1
    ```

- from inside docker 

    ```
        python3 inference.py
    ```

    OR 

    ``` 
        python3 inference.py --model $MODEL_NAME --image $IMAGE_NAME
    ```
