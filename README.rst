ImmunoProbs Docker
==================

`ImmunoProbs <https://github.com/penuts7644/immuno-probs>`__ and its dependencies bundled together in a single Docker image.


Getting started
^^^^^^^^^^^^^^^

It is also possible to use a Docker image of ImmunoProbs with all necessary requirement pre-installed in an ubuntu environment. Make sure to install `Docker <https://www.docker.com>`__ first and pull the most recent version of the image with the following command.

.. code-block:: none

    docker pull docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:0.2.1

Now you can use the ImmunoProbs image however you like (through calling ImmunoProbs directly or by opening an interactive session in the bash shell).

You can also execute the ImmunoProbs image while using files in your local machine's working directory as a mounted volume:

.. code-block:: none

    docker run --rm -v "$PWD":/tmp docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:0.2.1 \
      immuno-probs \
        [TOOL NAME] \
          <TOOL OPTIONS>

Note that the container is removed after execution and that you'll need to link to the ``/tmp`` directory of the container since that is the location where output files are created.

Some additional information on running Docker images can be found below:

-  `Copy files <https://docs.docker.com/engine/reference/commandline/cp/>`__ to/from the container (``docker cp``).

-  Run an image in a `detached <https://docs.docker.com/engine/reference/commandline/run/>`__ container (``docker run -d``) and `attach <https://docs.docker.com/engine/reference/commandline/attach/>`__ it later on (``docker attach``).


Tutorial
========

All commands below will be run inside the Docker image container. Log into the container with the following command:

.. code-block:: none

    docker run --rm -it docker.pkg.github.com/penuts7644/immuno-probs-docker/immuno-probs:0.2.1 bash

You can exit the terminal inside the container with ``exit``. The container is removed after exiting because of the ``--rm`` flag.


1. Using pre-trained models
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the first section of the tutorial, we will use a pre-trained IGoR model (**human TCR beta**) that comes included with ImmunoProbs. The included IGoR models can be used to generate and evaluate V(D)J or CDR3 sequences.


1a. Generate VJ, VDJ or CDR3 sequences
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Generating sequences can be done by specifying the model you would like to use (``-model``) and the number of sequences to generate (``-n-gen``).

.. code-block:: none

    immuno-probs \
      generate \
        -model human-t-beta \
        -n-gen 100

CDR3 sequences generation and evaluation requires additional V and J anchor index positions files, however, these files are also included with the models in ImmunoProbs. We just add the ``-cdr3`` flag to get CDR3 sequences instead of VDJ sequences.

.. code-block:: none

    immuno-probs \
      generate \
        -model human-t-beta \
        -n-gen 100 \
        -cdr3


1b. Calculate the generation probabilities for VJ, VDJ or CDR3 sequences
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We can calculate the generation probability of our VDJ sequences by specifying the input data through the ``-seqs`` command.

.. code-block:: none

    immuno-probs \
      evaluate \
        -model human-t-beta \
        -seqs <VDJ SEQUENCES>

Similar as with the VDJ sequence evaluation, but now we are using CDR3 input sequences so we’ll have to set the CDR3 flag (``-cdr3``).

.. code-block:: none

    immuno-probs \
      evaluate \
        -model human-t-beta \
        -seqs <CDR3 SEQUENCES> \
        -cdr3


2. Building your own model
^^^^^^^^^^^^^^^^^^^^^^^^^^

In the second part of the tutorial, we will create our own recombination model. For this part we will create a human VDJ beta chain model using the `zip archive <https://github.com/penuts7644/immuno-probs-docker/blob/master/tutorial_data.zip>`__ located in the GitHub project. Finally, we are going to generate and evaluate sequences using our created model. The unzipped data is included in the ``tutorial_data`` directory in the root of the ImmunoProbs Docker image.


2a. Building a model
~~~~~~~~~~~~~~~~~~~~

We'll start by specifying the germline IMGT templates (``-ref``) for the V, D and J gene. In addition, we'll select our inference sequences (``-seqs``), specify the number of training rounds (``-n-iter``) and the desired type of the model we would like to build (``-type``).

.. code-block:: none

    immuno-probs \
      build \
        -ref V /tutorial_data/TRBV.fasta \
        -ref D /tutorial_data/TRBD.fasta \
        -ref J /tutorial_data/TRBJ.fasta \
        -seqs /tutorial_data/1000_sample_seqs.tsv \
        -n-iter 10 \
        -type beta


2b. Locate CDR3 anchors positions for CDR3 generation and evaluation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CDR3 anchor positions are required in order to accurately generate and evaluate CDR3 sequences. Specify the V and J germline reference sequences with the ``-ref`` option.

.. code-block:: none

    immuno-probs \
      locate \
        -ref V /tutorial_data/TRBV.fasta \
        -ref J /tutorial_data/TRBJ.fasta


2c. Generate VJ, VDJ or CDR3 sequences
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We need to specify our model marginals and parameters (``-custom-model``) files as well as the model type (``-type``).

.. code-block:: none

    immuno-probs \
      generate \
        -custom-model /tutorial_data/model_params.txt /tutorial_data/model_marginals.txt \
        -n-gen 100 \
        -type beta

To generate some CDR3 sequences, we'll add the ``-cdr3`` flag at the end of the command and specify the anchor position files created in section **2b** with ``-anchor`` flag.

.. code-block:: none

    immuno-probs \
      generate \
        -custom-model /tutorial_data/model_params.txt /tutorial_data/model_marginals.txt \
        -n-gen 100 \
        -type beta \
        -cdr3 \
        -anchor V /tutorial_data/V_gene_CDR3_anchors.tsv \
        -anchor J /tutorial_data/J_gene_CDR3_anchors.tsv


2d. Calculate the generation probabilities for VJ, VDJ or CDR3 sequences
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We are selecting the sequences generated in **2c** (``-seqs``), the model parameters and marginals (``-custom-model``), the type of the input model and the germline templates (``-ref``)

.. code-block:: none

    immuno-probs \
      evaluate \
        -custom-model /tutorial_data/model_params.txt /tutorial_data/model_marginals.txt \
        -seqs /tutorial_data/generated_seqs_beta.tsv \
        -type beta \
        -ref V /tutorial_data/TRBV.fasta \
        -ref D /tutorial_data/TRBD.fasta \
        -ref J /tutorial_data/TRBJ.fasta

To evaluate CDR3 sequences generated in the previous section, we'll add the ``-cdr3`` flag at the end the command and replace the ``-ref`` flags with the ``-anchor`` ones. For CDR3 we don't need germline templates.

.. code-block:: none

    immuno-probs \
      evaluate \
        -custom-model /tutorial_data/model_params.txt /tutorial_data/model_marginals.txt \
        -seqs /tutorial_data/generated_seqs_beta_CDR3.tsv \
        -type beta \
        -cdr3 \
        -anchor V /tutorial_data/V_gene_CDR3_anchors.tsv \
        -anchor J /tutorial_data/J_gene_CDR3_anchors.tsv
