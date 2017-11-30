# OpenDDS Messenger on Kubernetes

This repository contains a version of the Messenger example from [OpenDDS](http://github.com/objectcomputing/OpenDDS) that has been modified to run in Kubernetes.

## Overview

The deployment consists of three containers:  a publisher, a subscriber, and an InfoRepo.
The InfoRepo is a centralized approach to discovery that allows the publisher and subscriber to find each other.
The InfoRepo is run as a *service* in Kubernetes.
The major consequence of this is that the InfoRepo has a DNS record can be resolved by both the publisher and the subscriber.

Other forms of discovery are possible but will require additions to OpenDDS and/or Kubernetes.
For example, the SPDP multicast protocol of RTPS is not supported out of the box in Kubernetes as multicast is not supported across hosts by default.
Similarly, it may be possible to use the Kubernetes meta-data servers to record information about available participants.
This would require adding another discovery mechanism to OpenDDS and providing the corresponding support in Kubernetes.

## Prerequisites

To follow this tutorial, you will need:

1. Familiarity with building OpenDDS applications.  See <http://opendds.org/quickstart/GettingStartedDocker.html>
2. Docker
2. A Kubernetes cluster
3. A Docker image repository

## Building

Build the publisher and subscriber:

    cd KubernetesMessenger
    docker run --rm -ti -v "$PWD:/opt/workspace" objectcomputing/opendds:release-DDS-3.12
    mwc.pl -type gnuace
    make
    exit

Build a Docker image with the publisher and subscriber:

    docker build -t myrepo/my-image .

Push the image to your repository:

    docker push myrepo/my-image

## Deploying

Deploy the InfoRepo:

    kubectl apply -f deploy/info-repo.yml
    
Deploy the subscriber:

    kubectl apply -f deploy/subscriber.yml
    
Deploy the publisher:

    kubectl apply -f deploy/publisher.yml
    
Check the logs:

    kubectl logs deploy/publisher
    kubectl logs deploy/subscriber
    
## How it works

* The InfoRepo runs as service named `info-repo` and exposes port 3897 (`deploy/info-repo.yml`).
* The InfoRepo is configured to work behind a load balancer with `-ORBListenEndpoints iiop://:3897/hostname_in_ior=info-repo` (`deploy/info-repo.yml`).
* The publisher and subscriber are configured to use the InfoRepo with `-DCPSInfoRepo info-repo:3897` (`deploy/publisher.yml` and `deploy/subscriber.yml`).



