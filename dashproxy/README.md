Dash Reverse Proxy Docker Image
===============================

Running the container with a url will force the proxy to pull down configuration from the given url.

Otherwise, running with defaults will
    - listen at port 8888
    - disable auth
    - not loading public key for auth verification
    - auth scope is '*' which is allows all

