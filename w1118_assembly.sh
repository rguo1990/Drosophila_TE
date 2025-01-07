## The raw HiFi reads are saved as: ~/Drosophila_genomes/w1118/demultiplex.bc1017--bc1017.hifi_reads_fastq

## Assembler: Hifiasm
## Filter criteria: reads should be longer than 6kb
## Filtering was done by cutadapt:
cutadapt -m 6000 -o ../w1118.filter.fastq demultiplex.bc1017--bc1017.hifi_reads_fastq

## The script used to run Hifiasm:
## Two options: with filtering or not

## With FILTERING:
#!/bin/bash

#SBATCH --job-name=hifiasm       ## Name of the job.
#SBATCH -A grylee_lab      ## CHANGE account to charge 
#SBATCH -p free               ## partition name
#SBATCH --nodes=1             ## (-N) number of nodes to use
#SBATCH --ntasks=1            ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=10     ## number of cores the job needs
#SBATCH --error=slurm-%J.err  ## error log file
#SBATCH --output=slurm-%J.out ## output log file

hifiasm -o w1118.filter.asm -t32 --write-ec ../w1118.filter.fastq 2>w1118.filter.asm.log

## Without FILTERING:
hifiasm -o w1118.asm -t32 --write-ec demultiplex.bc1017--bc1017.hifi_reads.fastq 2>w1118.asm.log

## saved in: ~/Drosophila_genomes/w1118

## the statistics of the primary contigs:
## stats for /data/homezvol0/rongg7/Drosophila_genomes/w1118/w1118.asm.fasta
## sum = 164268009, n = 193, ave = 851129.58, largest = 27963721
## N50 = 21563735, n = 4
## N60 = 15399632, n = 5
## N70 = 7362488, n = 6
## N80 = 1299991, n = 13
## N90 = 429469, n = 32
## N100 = 18114, n = 193
## N_count = 0
## Gaps = 0

## stats for /data/homezvol0/rongg7/Drosophila_genomes/w1118/w1118.filter.asm.fasta
## sum = 164601684, n = 206, ave = 799037.30, largest = 27963719
## N50 = 21563737, n = 4
## N60 = 15399646, n = 5
## N70 = 7362488, n = 6
## N80 = 1230914, n = 14
## N90 = 383150, n = 35
## N100 = 18385, n = 206
## N_count = 0
## Gaps = 0

## If only considering the stats, it looks better when we don't filter the raw reads, so we will take w1118.asm.fasta for future analysis.

## Next, we did some filtering using GenomeFLTR (Dotan et al, 2023). Align the scaffolds against NCBI nr database, 
## and filter out those mapped scaffolds with Kraken standard, (i.e. all complete bacterial, archeal, and viral genomes in Refseq)
## The filtered 149 scaffolds were saved as: ~/Drosophila_genomes/w1118/assemblies/FilteredResults.fasta

## Then, we performed reference-assisted assembly using RagTag.
## install with conda (under environment ragtag_envs)
## conda install -c bioconda ragtag

ragtag.py scaffold ~/Drosophila_ref.fasta ~/Drosophila_genomes/w1118/assemblies/FilteredResult_relabel_geno.chr.fasta -o ~/Drosophila_genomes/Ragout/bin/ragtag_output

head -n 14 ragtag.scaffold.fasta > w1118_ref.fasta
## w1118_ref.fasta is the chromosomal-scale assembly of w1118, and each gap was filled with 100 Ns.

## stats for /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/ragtag_output/ragtag.scaffold.fasta
## sum = 161781792, n = 98, ave = 1650834.61, largest = 34825399
## N50 = 26933598, n = 3
## N60 = 25937454, n = 4
## N70 = 25937454, n = 4
## N80 = 24106939, n = 5
## N90 = 8181268, n = 6
## N100 = 18114, n = 98
## N_count = 5100
## Gaps = 51

## stats for ../../Ragout/bin/ragtag_output/w1118_ref.fasta
## sum = 151137149, n = 7, ave = 21591021.29, largest = 34825399
## N50 = 26933598, n = 3
## N60 = 26933598, n = 3
## N70 = 25937454, n = 4
## N80 = 24106939, n = 5
## N90 = 24106939, n = 5
## N100 = 1867927, n = 7
## N_count = 5100
## Gaps = 51

## The completeness of the w1118 assembly was measured using compleasm:

Last login: Thu Dec 19 12:08:05 on ttys000
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
Success. Logging you in...
+-----------------------------------------+
|  _             _             _ _  __    |
| | | ___   __ _(_)_ __       (_) |/ /_   |
| | |/ _ \ / _` | | '_ \ _____| | | '_ \  |
| | | (_) | (_| | | | | |_____| | | (_) | |
| |_|\___/ \__, |_|_| |_|     |_|_|\___/  |
|          |___/                          |
+-----------------------------------------+
 Distro:  Rocky 8.10 Green Obsidian
 Virtual: NO

 CPUs:    40
 RAM:     191.5GB
 BUILT:   2024-12-18 14:02

 RCIC WEBSITE: https://rcic.uci.edu
 ACCEPTABLE USE: https://rcic.uci.edu/account/acceptable-use.html
 SLURM GUIDE: https://rcic.uci.edu/slurm/slurm.html

 QUOTA ISSUES?: https://rcic.uci.edu/help/faq.html#disk-quotas

Last login: Fri Dec 20 10:17:52 2024 from 10.240.58.12
(base) [rongg7@login-i16:~] $ls
Drosophila_genomes
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta
(base) [rongg7@login-i16:~/Drosophila_genomes] $module load miniconda3/
(base) [rongg7@login-i16:~/Drosophila_genomes] $conda activate myenv
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $conda install -c bioconda ragout
Channels:
 - bioconda
 - conda-forge
 - defaults
 - qiime2
Platform: linux-64
Collecting package metadata (repodata.json): done
Solving environment: - warning  libmamba Added empty dependency for problem type SOLVER_RULE_UPDATE
failed

LibMambaUnsatisfiableError: Encountered problems while solving:
  - nothing provides networkx 1.8 needed by ragout-2.0-py27_2

Could not solve for environment specs
The following packages are incompatible
├─ pin-1 is installable and it requires
│  └─ python 3.5.* , which can be installed;
└─ ragout is not installable because there are no viable options
   ├─ ragout [2.0|2.2|2.3] would require
   │  └─ python [2.7* |>=2.7,<2.8.0a0 ], which conflicts with any installable versions previously reported;
   ├─ ragout [2.0|2.1|2.1.1] would require
   │  └─ networkx 1.8 , which does not exist (perhaps a missing channel);
   ├─ ragout 2.3 would require
   │  └─ python >=3.6,<3.7.0a0 , which conflicts with any installable versions previously reported;
   ├─ ragout 2.3 would require
   │  └─ python >=3.7,<3.8.0a0 , which conflicts with any installable versions previously reported;
   └─ ragout 2.3 would require
      └─ python >=3.8,<3.9.0a0 , which conflicts with any installable versions previously reported.

(myenv) [rongg7@login-i16:~/Drosophila_genomes] $pip install networkx
DEPRECATION: Python 3.5 reached the end of its life on September 13th, 2020. Please upgrade your Python as Python 3.5 is no longer maintained. pip 21.0 will drop support for Python 3.5 in January 2021. pip 21.0 will remove support for this functionality.
Collecting networkx
  Downloading networkx-2.4-py3-none-any.whl (1.6 MB)
     |████████████████████████████████| 1.6 MB 20.5 MB/s 
Collecting decorator>=4.3.0
  Downloading decorator-5.1.1-py3-none-any.whl (9.1 kB)
Installing collected packages: decorator, networkx
Successfully installed decorator-5.1.1 networkx-2.4
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $conda install -c bioconda ragout
Channels:
 - bioconda
 - conda-forge
 - defaults
 - qiime2
Platform: linux-64
Collecting package metadata (repodata.json): done
Solving environment: / warning  libmamba Added empty dependency for problem type SOLVER_RULE_UPDATE
failed

LibMambaUnsatisfiableError: Encountered problems while solving:
  - nothing provides networkx 1.8 needed by ragout-2.0-py27_2

Could not solve for environment specs
The following packages are incompatible
├─ pin-1 is installable and it requires
│  └─ python 3.5.* , which can be installed;
└─ ragout is not installable because there are no viable options
   ├─ ragout [2.0|2.2|2.3] would require
   │  └─ python [2.7* |>=2.7,<2.8.0a0 ], which conflicts with any installable versions previously reported;
   ├─ ragout [2.0|2.1|2.1.1] would require
   │  └─ networkx 1.8 , which does not exist (perhaps a missing channel);
   ├─ ragout 2.3 would require
   │  └─ python >=3.6,<3.7.0a0 , which conflicts with any installable versions previously reported;
   ├─ ragout 2.3 would require
   │  └─ python >=3.7,<3.8.0a0 , which conflicts with any installable versions previously reported;
   └─ ragout 2.3 would require
      └─ python >=3.8,<3.9.0a0 , which conflicts with any installable versions previously reported.

(myenv) [rongg7@login-i16:~/Drosophila_genomes] $lls
bash: lls: command not found...
Similar command is: 'ls'
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $git clone https://github.com/fenderglass/Ragout.git
Cloning into 'Ragout'...
remote: Enumerating objects: 4941, done.
remote: Counting objects: 100% (42/42), done.
remote: Compressing objects: 100% (41/41), done.
remote: Total 4941 (delta 16), reused 3 (delta 1), pack-reused 4899 (from 1)
Receiving objects: 100% (4941/4941), 24.46 MiB | 14.12 MiB/s, done.
Resolving deltas: 100% (3176/3176), done.
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $ls
bin  docs  examples  LICENSE  Makefile  ragout  README.md  requirements.txt  scripts  setup.py
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $python setup.py build
running build
running build_py
creating build
creating build/lib
creating build/lib/ragout
copying ragout/six.py -> build/lib/ragout
copying ragout/__init__.py -> build/lib/ragout
copying ragout/main.py -> build/lib/ragout
copying ragout/__version__.py -> build/lib/ragout
creating build/lib/ragout/assembly_graph
copying ragout/assembly_graph/__init__.py -> build/lib/ragout/assembly_graph
copying ragout/assembly_graph/assembly_refine.py -> build/lib/ragout/assembly_graph
creating build/lib/ragout/breakpoint_graph
copying ragout/breakpoint_graph/repeat_resolver.py -> build/lib/ragout/breakpoint_graph
copying ragout/breakpoint_graph/chimera_detector.py -> build/lib/ragout/breakpoint_graph
copying ragout/breakpoint_graph/breakpoint_graph.py -> build/lib/ragout/breakpoint_graph
copying ragout/breakpoint_graph/inferer.py -> build/lib/ragout/breakpoint_graph
copying ragout/breakpoint_graph/__init__.py -> build/lib/ragout/breakpoint_graph
copying ragout/breakpoint_graph/permutation.py -> build/lib/ragout/breakpoint_graph
creating build/lib/ragout/maf2synteny
copying ragout/maf2synteny/__init__.py -> build/lib/ragout/maf2synteny
copying ragout/maf2synteny/maf2synteny.py -> build/lib/ragout/maf2synteny
creating build/lib/ragout/overlap
copying ragout/overlap/overlap.py -> build/lib/ragout/overlap
copying ragout/overlap/__init__.py -> build/lib/ragout/overlap
creating build/lib/ragout/parsers
copying ragout/parsers/fasta_parser.py -> build/lib/ragout/parsers
copying ragout/parsers/recipe_parser.py -> build/lib/ragout/parsers
copying ragout/parsers/phylogeny_parser.py -> build/lib/ragout/parsers
copying ragout/parsers/__init__.py -> build/lib/ragout/parsers
creating build/lib/ragout/phylogeny
copying ragout/phylogeny/inferer.py -> build/lib/ragout/phylogeny
copying ragout/phylogeny/phylogeny.py -> build/lib/ragout/phylogeny
copying ragout/phylogeny/__init__.py -> build/lib/ragout/phylogeny
creating build/lib/ragout/scaffolder
copying ragout/scaffolder/__init__.py -> build/lib/ragout/scaffolder
copying ragout/scaffolder/merge_iters.py -> build/lib/ragout/scaffolder
copying ragout/scaffolder/output_generator.py -> build/lib/ragout/scaffolder
copying ragout/scaffolder/scaffolder.py -> build/lib/ragout/scaffolder
creating build/lib/ragout/shared
copying ragout/shared/__init__.py -> build/lib/ragout/shared
copying ragout/shared/utils.py -> build/lib/ragout/shared
copying ragout/shared/debug.py -> build/lib/ragout/shared
copying ragout/shared/config.py -> build/lib/ragout/shared
copying ragout/shared/datatypes.py -> build/lib/ragout/shared
creating build/lib/ragout/synteny_backend
copying ragout/synteny_backend/synteny_backend.py -> build/lib/ragout/synteny_backend
copying ragout/synteny_backend/cactus.py -> build/lib/ragout/synteny_backend
copying ragout/synteny_backend/maf.py -> build/lib/ragout/synteny_backend
copying ragout/synteny_backend/__init__.py -> build/lib/ragout/synteny_backend
copying ragout/synteny_backend/hal.py -> build/lib/ragout/synteny_backend
copying ragout/synteny_backend/sibelia.py -> build/lib/ragout/synteny_backend
creating build/lib/ragout/newick
copying ragout/newick/lexer.py -> build/lib/ragout/newick
copying ragout/newick/tokens.py -> build/lib/ragout/newick
copying ragout/newick/__init__.py -> build/lib/ragout/newick
copying ragout/newick/tree.py -> build/lib/ragout/newick
copying ragout/newick/parser.py -> build/lib/ragout/newick
creating build/lib/ragout/tests
copying ragout/tests/__init__.py -> build/lib/ragout/tests
copying ragout/tests/test_toy.py -> build/lib/ragout/tests
creating build/lib/ragout/tests/data
copying ragout/tests/data/mg1655.coords -> build/lib/ragout/tests/data
copying ragout/tests/data/ecoli.rcp -> build/lib/ragout/tests/data
copying ragout/tests/data/DH1.fasta -> build/lib/ragout/tests/data
copying ragout/tests/data/mg1655_contigs.fasta -> build/lib/ragout/tests/data
make -C ragout/overlap/cpp_impl all
make[1]: Entering directory '/data/homezvol0/rongg7/Drosophila_genomes/Ragout/ragout/overlap/cpp_impl'
g++ -c -std=c++0x -Wall -O2 -DNDEBUG fasta.cpp -o fasta.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG suffix_array.cpp -o suffix_array.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG build_graph.cpp -o build_graph.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG main.cpp -o main.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG overlap.cpp -o overlap.o
g++  fasta.o suffix_array.o build_graph.o main.o overlap.o -o /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/ragout-overlap
make[1]: Leaving directory '/data/homezvol0/rongg7/Drosophila_genomes/Ragout/ragout/overlap/cpp_impl'
make -C ragout/maf2synteny/cpp_impl all
make[1]: Entering directory '/data/homezvol0/rongg7/Drosophila_genomes/Ragout/ragout/maf2synteny/cpp_impl'
g++ -c -std=c++0x -Wall -O2 -DNDEBUG breakpoint_graph.cpp -o breakpoint_graph.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG permutation.cpp -o permutation.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG compress_algorithms.cpp -o compress_algorithms.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG maf_tools.cpp -o maf_tools.o
g++ -c -std=c++0x -Wall -O2 -DNDEBUG main.cpp -o main.o
g++  breakpoint_graph.o permutation.o compress_algorithms.o maf_tools.o main.o -o /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/ragout-maf2synteny
make[1]: Leaving directory '/data/homezvol0/rongg7/Drosophila_genomes/Ragout/ragout/maf2synteny/cpp_impl'
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $pip install -r requirements.txt --rongg7

Usage:   
  pip install [options] <requirement specifier> [package-index-options] ...
  pip install [options] -r <requirements file> [package-index-options] ...
  pip install [options] [-e] <vcs project url> ...
  pip install [options] [-e] <local project path> ...
  pip install [options] <archive url/path> ...

no such option: --rongg7
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $pip install -r requirements.txt --user
DEPRECATION: Python 3.5 reached the end of its life on September 13th, 2020. Please upgrade your Python as Python 3.5 is no longer maintained. pip 21.0 will drop support for Python 3.5 in January 2021. pip 21.0 will remove support for this functionality.
Requirement already satisfied: setuptools in /data/homezvol0/rongg7/.conda/envs/myenv/lib/python3.5/site-packages (from -r requirements.txt (line 1)) (40.4.3)
Collecting networkx==2.2
  Downloading networkx-2.2.zip (1.7 MB)
     |████████████████████████████████| 1.7 MB 22.1 MB/s 
Requirement already satisfied: decorator>=4.3.0 in /data/homezvol0/rongg7/.conda/envs/myenv/lib/python3.5/site-packages (from networkx==2.2->-r requirements.txt (line 2)) (5.1.1)
Building wheels for collected packages: networkx
  Building wheel for networkx (setup.py) ... done
  Created wheel for networkx: filename=networkx-2.2-py2.py3-none-any.whl size=1526904 sha256=596e87222614509edef197c5551890d9d45e382e50291325c42ed647790b5ac1
  Stored in directory: /data/homezvol0/rongg7/.cache/pip/wheels/d7/04/13/c8e685a798c75f7aa1f6b0a4aaf201bd6422bb933981cd47f7
Successfully built networkx
Installing collected packages: networkx
Successfully installed networkx-2.2
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $ls
bin  build  docs  examples  LICENSE  Makefile  ragout  README.md  requirements.txt  scripts  setup.py
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $python scripts/install-sibelia.py
Installing Sibelia
Downloading source...
CMake Deprecation Warning at CMakeLists.txt:1 (cmake_minimum_required):
  Compatibility with CMake < 2.8.12 will be removed from a future version of
  CMake.

  Update the VERSION argument <min> value or use a ...<max> suffix to tell
  CMake that the project does not need compatibility with older versions.


-- The CXX compiler identification is GNU 8.5.0
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
CMake Deprecation Warning at libdivsufsort-2.0.1/CMakeLists.txt:2 (cmake_minimum_required):
  Compatibility with CMake < 2.8.12 will be removed from a future version of
  CMake.

  Update the VERSION argument <min> value or use a ...<max> suffix to tell
  CMake that the project does not need compatibility with older versions.


-- The C compiler identification is GNU 8.5.0
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working C compiler: /usr/bin/cc - skipped
-- Detecting C compile features
-- Detecting C compile features - done
-- Performing Test HAVE_GCC_WALL
-- Performing Test HAVE_GCC_WALL - Success
-- Performing Test HAVE_GCC_FOMIT_FRAME_POINTER
-- Performing Test HAVE_GCC_FOMIT_FRAME_POINTER - Success
-- Looking for inttypes.h
-- Looking for inttypes.h - found
-- Looking for memory.h
-- Looking for memory.h - found
-- Looking for stddef.h
-- Looking for stddef.h - found
-- Looking for stdint.h
-- Looking for stdint.h - found
-- Looking for stdlib.h
-- Looking for stdlib.h - found
-- Looking for string.h
-- Looking for string.h - found
-- Looking for strings.h
-- Looking for strings.h - found
-- Looking for sys/types.h
-- Looking for sys/types.h - found
-- Performing Test HAVE_INLINE
-- Performing Test HAVE_INLINE - Success
-- Performing Test HAVE___INLINE
-- Performing Test HAVE___INLINE - Success
-- Performing Test HAVE___INLINE__
-- Performing Test HAVE___INLINE__ - Success
-- Performing Test HAVE___DECLSPEC_DLLEXPORT_
-- Performing Test HAVE___DECLSPEC_DLLEXPORT_ - Failed
-- Performing Test HAVE___DECLSPEC_DLLIMPORT_
-- Performing Test HAVE___DECLSPEC_DLLIMPORT_ - Failed
-- Check size of uint8_t
-- Check size of uint8_t - done
-- Check size of int32_t
-- Check size of int32_t - done
-- Looking for PRId32
-- Looking for PRId32 - found
-- Configuring done (3.4s)
-- Generating done (0.0s)
-- Build files have been written to: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/build
[  4%] Building C object libdivsufsort-2.0.1/lib/CMakeFiles/divsufsort.dir/divsufsort.o
[  8%] Building C object libdivsufsort-2.0.1/lib/CMakeFiles/divsufsort.dir/sssort.o
[ 12%] Building C object libdivsufsort-2.0.1/lib/CMakeFiles/divsufsort.dir/trsort.o
[ 16%] Building C object libdivsufsort-2.0.1/lib/CMakeFiles/divsufsort.dir/utils.o
[ 20%] Linking C static library libdivsufsort.a
[ 20%] Built target divsufsort
[ 24%] Building CXX object CMakeFiles/Sibelia.dir/sibelia.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp: In function ‘int main(int, char**)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:239:8: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<SyntenyFinder::BlockFinder> finder(inRAM.isSet() ? new SyntenyFinder::BlockFinder(chrList) : new SyntenyFinder::BlockFinder(chrList, tempDir));
        ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/Arg.h:38,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/SwitchArg.h:30,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/tclap/CmdLine.h:27,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/maybe_include.hpp:23,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/function_iterate.hpp:14,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/preprocessor/iteration/detail/iter/forward1.hpp:57,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:64,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp: In instantiation of ‘void boost::detail::function::basic_vtable2<R, T0, T1>::assign_functor(FunctionObj, boost::detail::function::function_buffer&, mpl_::true_) const [with FunctionObj = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&; mpl_::true_ = mpl_::bool_<true>]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:602:13:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(FunctionObj, boost::detail::function::function_buffer&, boost::detail::function::function_obj_tag) const [with FunctionObj = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:492:45:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(F, boost::detail::function::function_buffer&) const [with F = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:936:7:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:278:107:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:566:49: warning: placement new constructing an object of type ‘boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >’ and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
           new (reinterpret_cast<void*>(&functor.data)) FunctionObj(f);
                                         ~~~~~~~~^~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/prologue.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:24,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:8:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp: In instantiation of ‘static void boost::detail::function::functor_manager_common<Functor>::manage_small(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:364:56:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, mpl_::true_) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; mpl_::true_ = mpl_::bool_<true>]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:412:18:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, boost::detail::function::function_obj_tag) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:440:20:   required from ‘static void boost::detail::function::functor_manager<Functor>::manage(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:934:13:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = const std::vector<SyntenyFinder::BlockInstance>&; T1 = const std::__cxx11::basic_string<char>&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/sibelia.cpp:278:107:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:318:54: warning: placement new constructing an object of type ‘boost::detail::function::functor_manager_common<boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > > >::functor_type’ {aka ‘boost::_bi::bind_t<void, boost::_mfi::cmf2<void, SyntenyFinder::OutputGenerator, const std::vector<SyntenyFinder::BlockInstance>&, const std::__cxx11::basic_string<char>&>, boost::_bi::list3<boost::reference_wrapper<const SyntenyFinder::OutputGenerator>, boost::arg<1>, boost::arg<2> > >’} and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
             new (reinterpret_cast<void*>(&out_buffer.data)) functor_type(*in_functor);
                                           ~~~~~~~~~~~^~~~
[ 28%] Building CXX object CMakeFiles/Sibelia.dir/postprocessor.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:13,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/bits/locale_conv.h:41,
                 from /usr/include/c++/8/locale:43,
                 from /usr/include/c++/8/iomanip:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file/file_array.h:37,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/file.h:72,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score/score_matrix.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/score.h:48,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:44,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/basic.h:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/sequence.h:50,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:43,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
In function ‘void seqan::allocate(T&, TValue*&, TSize, seqan::Tag<TUsage>) [with T = seqan::String<seqan::ScoreAndID<int, long unsigned int>, seqan::Alloc<void> >; TValue = seqan::ScoreAndID<int, long unsigned int>; TSize = long unsigned int; TUsage = seqan::AllocateStorage_]’,
    inlined from ‘typename seqan::Value<seqan::String<TValue, seqan::Alloc<TSpec> > >::Type* seqan::_allocateStorage(seqan::String<TValue, seqan::Alloc<TSpec> >&, size_t) [with TValue = seqan::ScoreAndID<int, long unsigned int>; TSpec = void]’ at /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/sequence/string_alloc.h:340:13,
    inlined from ‘TScoreValue seqan::_smithWaterman(seqan::Align<TSource, TSpec>&, seqan::LocalAlignmentFinder<TScoreValue>&, const seqan::Score<TScoreValue, seqan::Simple>&, TScoreValue) [with TSource = seqan::String<char, seqan::Alloc<void> >; TSpec = seqan::ArrayGaps; TScoreValue = int]’ at /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/sequence/string_base.h:1430:28:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/basic/basic_allocator_interface.h:199:34: warning: argument 1 value ‘18446744073709551584’ exceeds maximum object size 9223372036854775807 [-Walloc-size-larger-than=]
 */ data = (TValue *) operator new(count * sizeof(TValue));
                      ~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~
In file included from /usr/include/c++/8/ext/new_allocator.h:33,
                 from /usr/include/c++/8/x86_64-redhat-linux/bits/c++allocator.h:33,
                 from /usr/include/c++/8/bits/allocator.h:46,
                 from /usr/include/c++/8/deque:61,
                 from /usr/include/c++/8/stack:60,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/seqan/align.h:40,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/postprocessor.cpp:9:
/usr/include/c++/8/new: In function ‘TScoreValue seqan::_smithWaterman(seqan::Align<TSource, TSpec>&, seqan::LocalAlignmentFinder<TScoreValue>&, const seqan::Score<TScoreValue, seqan::Simple>&, TScoreValue) [with TSource = seqan::String<char, seqan::Alloc<void> >; TSpec = seqan::ArrayGaps; TScoreValue = int]’:
/usr/include/c++/8/new:120:7: note: in a call to allocation function ‘void* operator new(std::size_t)’ declared here
 void* operator new(std::size_t) _GLIBCXX_THROW (std::bad_alloc)
       ^~~~~~~~
[ 32%] Building CXX object CMakeFiles/Sibelia.dir/indexedsequence.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 36%] Building CXX object CMakeFiles/Sibelia.dir/util.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 40%] Building CXX object CMakeFiles/Sibelia.dir/outputgenerator.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/util.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/outputgenerator.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 44%] Building CXX object CMakeFiles/Sibelia.dir/blockfinder.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 48%] Building CXX object CMakeFiles/Sibelia.dir/blockinstance.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/maybe_include.hpp:18,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/function_iterate.hpp:14,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/preprocessor/iteration/detail/iter/forward1.hpp:52,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:64,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp: In instantiation of ‘void boost::detail::function::basic_vtable1<R, T0>::assign_functor(FunctionObj, boost::detail::function::function_buffer&, mpl_::true_) const [with FunctionObj = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; mpl_::true_ = mpl_::bool_<true>]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:602:13:   required from ‘bool boost::detail::function::basic_vtable1<R, T0>::assign_to(FunctionObj, boost::detail::function::function_buffer&, boost::detail::function::function_obj_tag) const [with FunctionObj = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:492:45:   required from ‘bool boost::detail::function::basic_vtable1<R, T0>::assign_to(F, boost::detail::function::function_buffer&) const [with F = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:936:7:   required from ‘void boost::function1<R, T1>::assign_to(Functor) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function1<R, T1>::function1(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:12:58:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:566:49: warning: placement new constructing an object of type ‘boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >’ and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
           new (reinterpret_cast<void*>(&functor.data)) FunctionObj(f);
                                         ~~~~~~~~^~~~
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp: In instantiation of ‘void boost::detail::function::basic_vtable1<R, T0>::assign_functor(FunctionObj, boost::detail::function::function_buffer&, mpl_::true_) const [with FunctionObj = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; mpl_::true_ = mpl_::bool_<true>]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:602:13:   required from ‘bool boost::detail::function::basic_vtable1<R, T0>::assign_to(FunctionObj, boost::detail::function::function_buffer&, boost::detail::function::function_obj_tag) const [with FunctionObj = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:492:45:   required from ‘bool boost::detail::function::basic_vtable1<R, T0>::assign_to(F, boost::detail::function::function_buffer&) const [with F = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:936:7:   required from ‘void boost::function1<R, T1>::assign_to(Functor) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function1<R, T1>::function1(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:13:59:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:566:49: warning: placement new constructing an object of type ‘boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >’ and size ‘2’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/prologue.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:24,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp: In instantiation of ‘static void boost::detail::function::functor_manager_common<Functor>::manage_small(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:364:56:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, mpl_::true_) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; mpl_::true_ = mpl_::bool_<true>]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:412:18:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, boost::detail::function::function_obj_tag) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:440:20:   required from ‘static void boost::detail::function::functor_manager<Functor>::manage(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:934:13:   required from ‘void boost::function1<R, T1>::assign_to(Functor) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function1<R, T1>::function1(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:12:58:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:318:54: warning: placement new constructing an object of type ‘boost::detail::function::functor_manager_common<boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > > >::functor_type’ {aka ‘boost::_bi::bind_t<int, boost::_mfi::cmf0<int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >’} and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
             new (reinterpret_cast<void*>(&out_buffer.data)) functor_type(*in_functor);
                                           ~~~~~~~~~~~^~~~
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp: In instantiation of ‘static void boost::detail::function::functor_manager_common<Functor>::manage_small(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:364:56:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, mpl_::true_) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; mpl_::true_ = mpl_::bool_<true>]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:412:18:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, boost::detail::function::function_obj_tag) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:440:20:   required from ‘static void boost::detail::function::functor_manager<Functor>::manage(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:934:13:   required from ‘void boost::function1<R, T1>::assign_to(Functor) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function1<R, T1>::function1(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >; R = long unsigned int; T0 = const SyntenyFinder::BlockInstance&; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.cpp:13:59:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:318:54: warning: placement new constructing an object of type ‘boost::detail::function::functor_manager_common<boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > > >::functor_type’ {aka ‘boost::_bi::bind_t<long unsigned int, boost::_mfi::cmf0<long unsigned int, SyntenyFinder::BlockInstance>, boost::_bi::list1<boost::arg<1> > >’} and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
[ 52%] Building CXX object CMakeFiles/Sibelia.dir/bifurcationstorage.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bifurcationstorage.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 56%] Building CXX object CMakeFiles/Sibelia.dir/bulgeremoval.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/maybe_include.hpp:23,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/function_iterate.hpp:14,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/preprocessor/iteration/detail/iter/forward1.hpp:57,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:64,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp: In instantiation of ‘void boost::detail::function::basic_vtable2<R, T0, T1>::assign_functor(FunctionObj, boost::detail::function::function_buffer&, mpl_::true_) const [with FunctionObj = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator; mpl_::true_ = mpl_::bool_<true>]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:602:13:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(FunctionObj, boost::detail::function::function_buffer&, boost::detail::function::function_obj_tag) const [with FunctionObj = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:492:45:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(F, boost::detail::function::function_buffer&) const [with F = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:936:7:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:313:81:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:566:49: warning: placement new constructing an object of type ‘boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >’ and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
           new (reinterpret_cast<void*>(&functor.data)) FunctionObj(f);
                                         ~~~~~~~~^~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/prologue.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:24,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp: In instantiation of ‘static void boost::detail::function::functor_manager_common<Functor>::manage_small(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:364:56:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, mpl_::true_) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; mpl_::true_ = mpl_::bool_<true>]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:412:18:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, boost::detail::function::function_obj_tag) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:440:20:   required from ‘static void boost::detail::function::functor_manager<Functor>::manage(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:934:13:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::DNASequence::StrandIterator; T1 = SyntenyFinder::DNASequence::StrandIterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/bulgeremoval.cpp:313:81:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:318:54: warning: placement new constructing an object of type ‘boost::detail::function::functor_manager_common<boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > > >::functor_type’ {aka ‘boost::_bi::bind_t<void, boost::_mfi::mf2<void, SyntenyFinder::BifurcationStorage, SyntenyFinder::DNASequence::StrandIterator, SyntenyFinder::DNASequence::StrandIterator>, boost::_bi::list3<boost::reference_wrapper<SyntenyFinder::BifurcationStorage>, boost::arg<1>, boost::arg<2> > >’} and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
             new (reinterpret_cast<void*>(&out_buffer.data)) functor_type(*in_functor);
                                           ~~~~~~~~~~~^~~~
[ 60%] Building CXX object CMakeFiles/Sibelia.dir/dnasequence.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 64%] Building CXX object CMakeFiles/Sibelia.dir/edge.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/edge.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 68%] Building CXX object CMakeFiles/Sibelia.dir/fasta.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.cpp::
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 72%] Building CXX object CMakeFiles/Sibelia.dir/serialization.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/serialization.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 76%] Building CXX object CMakeFiles/Sibelia.dir/synteny.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:11,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockinstance.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/blockfinder.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/synteny.cpp:9:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 80%] Building CXX object CMakeFiles/Sibelia.dir/test/unrolledlisttest.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:31,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:34,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:20,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/maybe_include.hpp:23,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/function_iterate.hpp:14,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/preprocessor/iteration/detail/iter/forward1.hpp:57,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:64,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:33,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp: In instantiation of ‘void boost::detail::function::basic_vtable2<R, T0, T1>::assign_functor(FunctionObj, boost::detail::function::function_buffer&, mpl_::true_) const [with FunctionObj = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; mpl_::true_ = mpl_::bool_<true>]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:602:13:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(FunctionObj, boost::detail::function::function_buffer&, boost::detail::function::function_obj_tag) const [with FunctionObj = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:492:45:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(F, boost::detail::function::function_buffer&) const [with F = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:936:7:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:79:64:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:566:49: warning: placement new constructing an object of type ‘boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >’ and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
           new (reinterpret_cast<void*>(&functor.data)) FunctionObj(f);
                                         ~~~~~~~~^~~~
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp: In instantiation of ‘void boost::detail::function::basic_vtable2<R, T0, T1>::assign_functor(FunctionObj, boost::detail::function::function_buffer&, mpl_::true_) const [with FunctionObj = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; mpl_::true_ = mpl_::bool_<true>]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:602:13:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(FunctionObj, boost::detail::function::function_buffer&, boost::detail::function::function_obj_tag) const [with FunctionObj = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:492:45:   required from ‘bool boost::detail::function::basic_vtable2<R, T0, T1>::assign_to(F, boost::detail::function::function_buffer&) const [with F = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:936:7:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:110:99   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:566:49: warning: placement new constructing an object of type ‘boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >’ and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/detail/prologue.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function.hpp:24,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/../common.h:33,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp: In instantiation of ‘static void boost::detail::function::functor_manager_common<Functor>::manage_small(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:364:56:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, mpl_::true_) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; mpl_::true_ = mpl_::bool_<true>]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:412:18:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, boost::detail::function::function_obj_tag) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:440:20:   required from ‘static void boost::detail::function::functor_manager<Functor>::manage(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:934:13:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 100>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:79:64:   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:318:54: warning: placement new constructing an object of type ‘boost::detail::function::functor_manager_common<boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > > >::functor_type’ {aka ‘boost::_bi::bind_t<void, void (*)(long unsigned int, SyntenyFinder::unrolled_list<int, int, 100>&, SyntenyFinder::unrolled_list<int, int, 100>::iterator, SyntenyFinder::unrolled_list<int, int, 100>::iterator), boost::_bi::list4<boost::_bi::value<long unsigned int>, boost::reference_wrapper<SyntenyFinder::unrolled_list<int, int, 100> >, boost::arg<1>, boost::arg<2> > >’} and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
             new (reinterpret_cast<void*>(&out_buffer.data)) functor_type(*in_functor);
                                           ~~~~~~~~~~~^~~~
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp: In instantiation of ‘static void boost::detail::function::functor_manager_common<Functor>::manage_small(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >]’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:364:56:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, mpl_::true_) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; mpl_::true_ = mpl_::bool_<true>]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:412:18:   required from ‘static void boost::detail::function::functor_manager<Functor>::manager(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type, boost::detail::function::function_obj_tag) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:440:20:   required from ‘static void boost::detail::function::functor_manager<Functor>::manage(const boost::detail::function::function_buffer&, boost::detail::function::function_buffer&, boost::detail::function::functor_manager_operation_type) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:934:13:   required from ‘void boost::function2<R, T1, T2>::assign_to(Functor) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:722:7:   required from ‘boost::function2<R, T1, T2>::function2(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_template.hpp:1069:16:   required from ‘boost::function<R(T0, T1)>::function(Functor, typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type) [with Functor = boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >; R = void; T0 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; T1 = SyntenyFinder::unrolled_list<int, int, 5>::iterator; typename boost::enable_if_c<boost::type_traits::ice_not<boost::is_integral<Functor>::value>::value, int>::type = int]’
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/test/unrolledlisttest.cpp:110:99   required from here
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/function/function_base.hpp:318:54: warning: placement new constructing an object of type ‘boost::detail::function::functor_manager_common<boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > > >::functor_type’ {aka ‘boost::_bi::bind_t<void, void (*)(std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> >&, std::vector<long unsigned int>&, SyntenyFinder::unrolled_list<int, int, 5>::iterator, SyntenyFinder::unrolled_list<int, int, 5>::iterator), boost::_bi::list4<boost::reference_wrapper<std::vector<std::pair<SyntenyFinder::unrolled_list<int, int, 5>::iterator, int> > >, boost::reference_wrapper<std::vector<long unsigned int> >, boost::arg<1>, boost::arg<2> > >’} and size ‘24’ in a region of type ‘char’ and size ‘1’ [-Wplacement-new=]
[ 84%] Building CXX object CMakeFiles/Sibelia.dir/platform.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/platform.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 88%] Building CXX object CMakeFiles/Sibelia.dir/stranditerator.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/stranditerator.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 92%] Building CXX object CMakeFiles/Sibelia.dir/vertexenumeration.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h: At global scope:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:37:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<DNASequence> sequence_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:38:8: warning:‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
   std::auto_ptr<BifurcationStorage> bifStorage_;
        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/fasta.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/dnasequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/hashing.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/indexedsequence.h:10,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/vertexenumeration.cpp:7:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[ 96%] Building CXX object CMakeFiles/Sibelia.dir/resource.cpp.o
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/mem_fn.hpp:25,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/mem_fn.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind/bind.hpp:26,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/bind.hpp:22,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/get_pointer.hpp:27:40: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template<class T> T * get_pointer(std::auto_ptr<T> const& p)
                                        ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:32,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/detail/shared_count.hpp:323:33: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_count( std::auto_ptr<Y> & r ): pi_( new sp_counted_impl_p<Y>( r.get() ) )
                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:247:65: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
 template< class T, class R > struct sp_enable_if_auto_ptr< std::auto_ptr< T >, R >
                                                                 ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:446:31: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     explicit shared_ptr( std::auto_ptr<Y> & r ): px(r.get()), pn()
                               ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:459:22: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr( std::auto_ptr<Y> && r ): px(r.get()), pn()
                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:525:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> & r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:534:34: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
     shared_ptr & operator=( std::auto_ptr<Y> && r )
                                  ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
In file included from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/shared_ptr.hpp:17,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:3,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp: In member function ‘boost::shared_ptr<T>& boost::shared_ptr<T>::operator=(std::auto_ptr<_Up>&&)’:
/data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/include/boost/smart_ptr/shared_ptr.hpp:536:38: warning: ‘template<class> class std::auto_ptr’ is deprecated [-Wdeprecated-declarations]
         this_type( static_cast< std::auto_ptr<Y> && >( r ) ).swap( *this );
                                      ^~~~~~~~
In file included from /usr/include/c++/8/memory:80,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/common.h:2,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.h:6,
                 from /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/Sibelia-master/src/resource.cpp:6:
/usr/include/c++/8/bits/unique_ptr.h:53:28: note: declared here
   template<typename> class auto_ptr;
                            ^~~~~~~~
[100%] Linking CXX executable Sibelia
[100%] Built target Sibelia
[ 20%] Built target divsufsort
[100%] Built target Sibelia
Install the project...
-- Install configuration: "Release"
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/bin/Sibelia
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/NEWS.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/ANNOTATION.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/README.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/USAGE.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/INSTALL.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/SIBELIA.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/C-SIBELIA.md
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/LICENSE.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/C-Sibelia
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/C-Sibelia/Staphylococcus_aureus
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/C-Sibelia/Staphylococcus_aureus/NCTC8325.fasta
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/C-Sibelia/Staphylococcus_aureus/variant.vcf
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/C-Sibelia/Staphylococcus_aureus/README.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/C-Sibelia/Staphylococcus_aureus/RN4220.fasta
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.highlight4.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.highlight3.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.conf
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.sequences.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.highlight2.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.highlight.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.png
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.highlight1.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.image.conf
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.segdup.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/circos/circos.svg
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/Helicobacter_pylori.fasta
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/blocks_coords.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/d3_blocks_diagram.html
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/README.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/genomes_permutations.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Helicobacter_pylori/coverage_report.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/d3_blocks_diagram.html
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.sequences.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.png
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.image.conf
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.conf
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.svg
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.highlight.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/circos/circos.segdup.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/coverage_report.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/Staphylococcus.fasta
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/genomes_permutations.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/blocks_coords.txt
-- Installing: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/sibelia-build/share/Sibelia/doc/examples/Sibelia/Staphylococcus_aureus/README.txt
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $ls
bin  build  docs  examples  LICENSE  Makefile  ragout  README.md  requirements.txt  scripts  setup.py
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $cd bin/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout  ragout-maf2synteny  ragout-overlap  Sibelia
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout
usage: ragout [-h] [-o output_dir] [-s {sibelia,maf,hal}] [--refine]
              [--solid-scaffolds] [--overwrite] [--repeats] [--debug]
              [-t THREADS] [--version]
              recipe_file
ragout: error: the following arguments are required: recipe_file
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ll ../..
total 543597
-rw-rw-r-- 1 rongg7 rongg7 174623702 Dec 20 13:04 A3.Hifi.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7 172464929 Dec 20 13:04 A4.Hifi.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7 176804740 Dec 20 13:04 a6.asm.bp.p_ctg.SCAF.fasta
-rw-rw-r-- 1 rongg7 rongg7 171849714 Dec 20 13:04 a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7 170697367 Dec 20 12:45 ISO1.Hifi.Scaf.fasta
drwxrwxr-x 9 rongg7 rongg7        16 Dec 20 13:20 Ragout
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./Sibelia
PARSE ERROR:  
             Required arguments missing: stagefile, parameters, filenames

Brief USAGE: 
   ./Sibelia  {-s <loose|fine|far>|-k <file name>} [-o <dir name>]
              [--noblocks] [-r] [-a] [-m <integer>] [-q] [-g] [-v] [-t <dir
              name>] [--lastk <integer > 1>] [--allstages] [--gff]
              [--nopostprocess] [--correctboundaries] [-i <integer > 0>]
              [--] [--version] [-h] <fasta files with genomes> ...

For complete USAGE and HELP type: 
   ./Sibelia --help

(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $conda install sibeliaz
Channels:
 - conda-forge
 - bioconda
 - defaults
 - qiime2
Platform: linux-64
Collecting package metadata (repodata.json): done
Solving environment: done

## Package Plan ##

  environment location: /data/homezvol0/rongg7/.conda/envs/myenv

  added / updated specs:
    - sibeliaz


The following packages will be downloaded:

    package                    |            build
    ---------------------------|-----------------
    icu-73.2                   |       h59595ed_0        11.5 MB  conda-forge
    libffi-3.3                 |       h58526e2_2          51 KB  conda-forge
    libhwloc-2.11.2            |default_h0d58e46_1001         2.3 MB  conda-forge
    libsqlite-3.46.0           |       hde9e2c9_0         845 KB  conda-forge
    libxml2-2.13.5             |       hfdd30dd_0         738 KB
    maf2synteny-1.2            |       h503566f_4          65 KB  bioconda
    openssl-1.1.1w             |       hd590300_0         1.9 MB  conda-forge
    python-3.5.6               |       h12debd9_1        24.9 MB
    readline-8.2               |       h8228510_1         275 KB  conda-forge
    sibeliaz-1.2.5             |       hc252753_4         106 KB  bioconda
    spoa-4.0.3                 |       he513fc3_0         103 KB  bioconda
    sqlite-3.46.0              |       h6d4b2fc_0         840 KB  conda-forge
    tbb-2022.0.0               |       hceb3a55_0         174 KB  conda-forge
    twopaco-1.0.0              |       hc252753_3         387 KB  bioconda
    ------------------------------------------------------------
                                           Total:        44.1 MB

The following NEW packages will be INSTALLED:

  icu                conda-forge/linux-64::icu-73.2-h59595ed_0 
  libhwloc           conda-forge/linux-64::libhwloc-2.11.2-default_h0d58e46_1001 
  libsqlite          conda-forge/linux-64::libsqlite-3.46.0-hde9e2c9_0 
  libxml2            pkgs/main/linux-64::libxml2-2.13.5-hfdd30dd_0 
  maf2synteny        bioconda/linux-64::maf2synteny-1.2-h503566f_4 
  sibeliaz           bioconda/linux-64::sibeliaz-1.2.5-hc252753_4 
  spoa               bioconda/linux-64::spoa-4.0.3-he513fc3_0 
  tbb                conda-forge/linux-64::tbb-2022.0.0-hceb3a55_0 
  twopaco            bioconda/linux-64::twopaco-1.0.0-hc252753_3 

The following packages will be UPDATED:

  libffi                                3.2.1-he1b5a44_1007 --> 3.3-h58526e2_2 
  openssl                                 1.0.2u-h516909a_0 --> 1.1.1w-hd590300_0 
  python               conda-forge::python-3.5.5-h5001a0f_2 --> pkgs/main::python-3.5.6-h12debd9_1 
  readline                                7.0-hf8c457e_1001 --> 8.2-h8228510_1 
  sqlite                                  3.28.0-h8b20d00_0 --> 3.46.0-h6d4b2fc_0 


Proceed ([y]/n)? y


Downloading and Extracting Packages:
                                                                                                                   
Preparing transaction: done                                                                                        
Verifying transaction: done                                                                                        
Executing transaction: done                                                                                        
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $sibeliaz
You must provide the input file name                                                                               
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $Connection to hpc3.rcic.uci.edu closed by remote host. 
Connection to hpc3.rcic.uci.edu closed.                                                                            
client_loop: send disconnect: Broken pipe                                                                          
rongguo@Rongs-MacBook-Pro ~ % 
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1

Success. Logging you in...
+-----------------------------------------+
|  _             _             _ _  __    |
| | | ___   __ _(_)_ __       (_) |/ /_   |
| | |/ _ \ / _` | | '_ \ _____| | | '_ \  |
| | | (_) | (_| | | | | |_____| | | (_) | |
| |_|\___/ \__, |_|_| |_|     |_|_|\___/  |
|          |___/                          |
+-----------------------------------------+
 Distro:  Rocky 8.10 Green Obsidian
 Virtual: NO

 CPUs:    40
 RAM:     191.5GB
 BUILT:   2024-12-18 14:02

 RCIC WEBSITE: https://rcic.uci.edu
 ACCEPTABLE USE: https://rcic.uci.edu/account/acceptable-use.html
 SLURM GUIDE: https://rcic.uci.edu/slurm/slurm.html

 QUOTA ISSUES?: https://rcic.uci.edu/help/faq.html#disk-quotas

 HOLIDAY SUPPORT: 
     HPC3 Operational. Only Critical Ticket Support.
     https://rcic.uci.edu/about/news.html#news-events

Last login: Fri Dec 20 13:13:03 2024 from 10.240.58.12

(base) [rongg7@login-i16:~] $
(base) [rongg7@login-i16:~] $ls
Drosophila_genomes  GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
(base) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $cd bin/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout  ragout-maf2synteny  ragout-overlap  Sibelia
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./Sibelia 
PARSE ERROR:  
             Required arguments missing: stagefile, parameters, filenames

Brief USAGE: 
   ./Sibelia  {-s <loose|fine|far>|-k <file name>} [-o <dir name>]
              [--noblocks] [-r] [-a] [-m <integer>] [-q] [-g] [-v] [-t <dir
              name>] [--lastk <integer > 1>] [--allstages] [--gff]
              [--nopostprocess] [--correctboundaries] [-i <integer > 0>]
              [--] [--version] [-h] <fasta files with genomes> ...

For complete USAGE and HELP type: 
   ./Sibelia --help

(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $sibeliaz
bash: sibeliaz: command not found...
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $module load miniconda3/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $conda activate myenv/

EnvironmentLocationNotFound: Not a conda environment: /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/myenv

(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $cd ..
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $ls
bin  build  docs  examples  LICENSE  Makefile  ragout  README.md  requirements.txt  scripts  setup.py
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $cd ..
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
(base) [rongg7@login-i16:~/Drosophila_genomes] $locate myenv
(base) [rongg7@login-i16:~/Drosophila_genomes] $conda activate myenv
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $sibeliaz
You must provide the input file name
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $sibeliaz ../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna ISO1.Hifi.Scaf.fasta 
Constructing the graph...
Threads = 16
Vertex length = 25
Hash functions = 5
Filter size = 17179869184
Capacity = 1
Files: 
../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna
ISO1.Hifi.Scaf.fasta
--------------------------------------------------------------------------------
Round 0, 0:17179869184
Pass	Filling	Filtering

1	211	358	
2	185	1
True junctions count = 470517
False junctions count = 964
Hash table size = 471481
Candidate marks count = 27423230
--------------------------------------------------------------------------------
Reallocating bifurcations time: 0
True marks count: 27422580
Edges construction time: 232
--------------------------------------------------------------------------------
Distinct junctions = 470517

TwoPaCo::buildGraphMain:: allocated with scalable_malloc; freeing.
TwoPaCo::buildGraphMain:: Calling scalable_allocation_command(TBBMALLOC_CLEAN_ALL_BUFFERS, 0);
Loading the graph...
Analyzing the graph...
[..................................................]
Generating the output...
Blocks found: 70667
Coverage: 0.96
Performing global alignment..


Read from remote host hpc3.rcic.uci.edu: Connection reset by peer
Connection to hpc3.rcic.uci.edu closed.
client_loop: send disconnect: Broken pipe
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
Success. Logging you in...
+-----------------------------------------+
|  _             _             _ _  __    |
| | | ___   __ _(_)_ __       (_) |/ /_   |
| | |/ _ \ / _` | | '_ \ _____| | | '_ \  |
| | | (_) | (_| | | | | |_____| | | (_) | |
| |_|\___/ \__, |_|_| |_|     |_|_|\___/  |
|          |___/                          |
+-----------------------------------------+
 Distro:  Rocky 8.10 Green Obsidian
 Virtual: NO

 CPUs:    40
 RAM:     191.5GB
 BUILT:   2024-12-18 14:02

 RCIC WEBSITE: https://rcic.uci.edu
 ACCEPTABLE USE: https://rcic.uci.edu/account/acceptable-use.html
 SLURM GUIDE: https://rcic.uci.edu/slurm/slurm.html

 QUOTA ISSUES?: https://rcic.uci.edu/help/faq.html#disk-quotas

 HOLIDAY SUPPORT: 
     HPC3 Operational. Only Critical Ticket Support.
     https://rcic.uci.edu/about/news.html#news-events

Last login: Mon Dec 23 11:17:29 2024 from 10.240.58.12
(base) [rongg7@login-i16:~] $ls
Drosophila_genomes  GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna  Hifiasm
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta  sibeliaz_out
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
(base) [rongg7@login-i16:~/Drosophila_genomes] $cd sibeliaz_out/
(base) [rongg7@login-i16:~/Drosophila_genomes/sibeliaz_out] $ls
0.msa    122.tmp  147.tmp  170.msa  193.msa  215.tmp  23.msa   32.tmp  56.tmp  79.tmp          block.51S6N.fa
0.tmp    123.msa  148.msa  170.tmp  193.tmp  216.msa  23.tmp   33.msa  57.msa  7.msa           block.7qrhf.fa
100.msa  123.tmp  148.tmp  171.msa  194.msa  216.tmp  240.msa  33.tmp  57.tmp  7.tmp           block.7UmEH.fa
100.tmp  124.msa  149.msa  171.tmp  194.tmp  217.msa  240.tmp  34.msa  58.msa  80.msa          block.80Kb4.fa
101.msa  124.tmp  149.tmp  172.msa  195.tmp  217.tmp  241.msa  34.tmp  58.tmp  80.tmp          block.9SkO0.fa
101.tmp  125.msa  14.msa   172.tmp  196.msa  218.msa  241.tmp  35.msa  59.msa  81.msa          block.AESLg.fa
102.msa  125.tmp  14.tmp   173.msa  196.tmp  218.tmp  242.tmp  35.tmp  59.tmp  81.tmp          block.b38yi.fa
102.tmp  126.msa  150.msa  173.tmp  197.msa  219.msa  243.msa  36.msa  5.msa   82.tmp          block.Dfq5t.fa
103.tmp  126.tmp  150.tmp  174.msa  197.tmp  219.tmp  243.tmp  36.tmp  5.tmp   83.msa          block.g9YXY.fa
104.tmp  127.tmp  151.msa  174.tmp  198.msa  21.tmp   244.msa  37.tmp  60.msa  83.tmp          block.hf57o.fa
105.msa  128.msa  151.tmp  175.msa  198.tmp  220.msa  244.tmp  38.msa  60.tmp  84.msa          block.Hgetx.fa
105.tmp  128.tmp  152.tmp  175.tmp  199.msa  220.tmp  245.tmp  38.tmp  61.msa  84.tmp          block.HIjxz.fa
106.msa  129.tmp  153.msa  176.msa  199.tmp  221.tmp  246.msa  39.tmp  61.tmp  85.tmp          block.IkOm8.fa
106.tmp  12.msa   153.tmp  176.tmp  19.msa   222.msa  246.tmp  3.msa   62.msa  86.msa          block.IL2DU.fa
107.msa  12.tmp   154.msa  177.msa  19.tmp   222.tmp  247.msa  3.tmp   62.tmp  86.tmp          block.iSLup.fa
107.tmp  130.msa  154.tmp  177.tmp  1.tmp    223.msa  247.tmp  40.msa  63.msa  87.msa          block.KG6ay.fa
108.msa  130.tmp  155.tmp  178.tmp  200.msa  223.tmp  248.msa  40.tmp  63.tmp  87.tmp          block.L0Oj5.fa
108.tmp  131.tmp  156.msa  179.msa  200.tmp  224.msa  248.tmp  41.msa  64.msa  88.msa          block.Lhze7.fa
109.msa  132.msa  156.tmp  179.tmp  201.msa  224.tmp  249.msa  41.tmp  64.tmp  88.tmp          block.MSiR6.fa
109.tmp  132.tmp  157.msa  17.msa   201.tmp  225.msa  249.tmp  42.tmp  65.msa  89.msa          block.OFzhQ.fa
10.msa   133.msa  157.tmp  17.tmp   202.tmp  225.tmp  24.msa   43.msa  65.tmp  89.tmp          block.OH4JO.fa
10.tmp   133.tmp  158.msa  180.msa  203.msa  226.tmp  24.tmp   43.tmp  66.msa  8.tmp           block.p0vSy.fa
110.msa  134.msa  158.tmp  180.tmp  203.tmp  227.msa  250.msa  44.msa  66.tmp  90.msa          block.P5fnr.fa
110.tmp  134.tmp  159.msa  181.msa  204.msa  227.tmp  250.tmp  44.tmp  67.msa  90.tmp          block.qxfyE.fa
111.msa  135.msa  159.tmp  181.tmp  204.tmp  228.tmp  251.msa  45.tmp  67.tmp  91.msa          block.RhYST.fa
111.tmp  135.tmp  15.msa   182.msa  205.tmp  229.msa  251.tmp  46.msa  68.msa  91.tmp          block.RitaM.fa
112.tmp  136.tmp  15.tmp   182.tmp  206.msa  229.tmp  252.msa  46.tmp  68.tmp  92.msa          block.rxjhJ.fa
113.msa  137.msa  160.tmp  183.tmp  206.tmp  22.msa   252.tmp  47.msa  69.msa  92.tmp          blocks_coords.gff
113.tmp  137.tmp  161.msa  184.tmp  207.msa  22.tmp   253.tmp  47.tmp  69.tmp  93.tmp          block.Sqqf1.fa
114.msa  138.tmp  161.tmp  185.msa  207.tmp  230.tmp  254.tmp  48.msa  6.tmp   94.tmp          block.v5t3i.fa
114.tmp  139.msa  162.msa  185.tmp  208.msa  231.msa  255.msa  48.tmp  70.tmp  95.msa          block.VeYcu.fa
115.tmp  139.tmp  162.tmp  186.msa  208.tmp  231.tmp  255.tmp  49.msa  71.msa  95.tmp          block.wlTlx.fa
116.msa  13.tmp   163.msa  186.tmp  209.msa  232.msa  25.msa   49.tmp  71.tmp  96.msa          block.WzgKN.fa
116.tmp  140.msa  163.tmp  187.msa  209.tmp  232.tmp  25.tmp   4.msa   72.msa  96.tmp          block.X66l9.fa
117.msa  140.tmp  164.msa  187.tmp  20.msa   233.msa  26.tmp   4.tmp   72.tmp  97.msa          block.xC5L7.fa
117.tmp  141.msa  164.tmp  188.msa  20.tmp   233.tmp  27.msa   50.msa  73.msa  97.tmp          block.yQ6iL.fa
118.msa  141.tmp  165.msa  188.tmp  210.msa  234.msa  27.tmp   50.tmp  73.tmp  98.msa          block.zm9cj.fa
118.tmp  142.msa  165.tmp  189.msa  210.tmp  234.tmp  28.tmp   51.msa  74.msa  98.tmp
119.msa  142.tmp  166.msa  189.tmp  211.msa  235.msa  29.msa   51.tmp  74.tmp  99.msa
119.tmp  143.tmp  166.tmp  18.msa   211.tmp  235.tmp  29.tmp   52.msa  75.msa  99.tmp
11.msa   144.tmp  167.tmp  18.tmp   212.msa  236.msa  2.msa    52.tmp  75.tmp  9.msa
11.tmp   145.msa  168.msa  190.msa  212.tmp  236.tmp  2.tmp    53.tmp  76.msa  9.tmp
120.tmp  145.tmp  168.tmp  190.tmp  213.tmp  237.tmp  30.tmp   54.tmp  76.tmp  alignment.maf
121.msa  146.msa  169.tmp  191.msa  214.msa  238.msa  31.msa   55.msa  77.tmp  block.0Eg9A.fa
121.tmp  146.tmp  16.msa   191.tmp  214.tmp  238.tmp  31.tmp   55.tmp  78.msa  block.0sULI.fa
122.msa  147.msa  16.tmp   192.tmp  215.msa  239.tmp  32.msa   56.msa  78.tmp  block.29fcz.fa
(base) [rongg7@login-i16:~/Drosophila_genomes/sibeliaz_out] $cd ..
(base) [rongg7@login-i16:~/Drosophila_genomes] $rm -r sibeliaz_out/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta  a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.fasta
A4.Hifi.Scaf.fasta  a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
(base) [rongg7@login-i16:~/Drosophila_genomes] $module load miniconda3/
(base) [rongg7@login-i16:~/Drosophila_genomes] $conda activate myenv
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $nano run_sibeliaz.sh
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $sebeliaz ISO1.Hifi.Scaf.fasta ../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna 
bash: sebeliaz: command not found...
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $nohup sibeliaz ISO1.Hifi.Scaf.fasta ../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna 
nohup: ignoring input and appending output to 'nohup.out'


Connection to hpc3.rcic.uci.edu closed by remote host.
Connection to hpc3.rcic.uci.edu closed.
client_loop: send disconnect: Broken pipe
rongguo@Rongs-MacBook-Pro ~ % scp rongg7@hpc3.rcic.uci.edu:/data/homezvol0/rongg7/Drosophila_genomes/w1118/assemblies/* ~/Downloads 
zsh: no matches found: rongg7@hpc3.rcic.uci.edu:/data/homezvol0/rongg7/Drosophila_genomes/w1118/assemblies/*
rongguo@Rongs-MacBook-Pro ~ % scp rongg7@hpc3.rcic.uci.edu:~/Drosophila_genomes/w1118/assemblies/* ~/Downloads
zsh: no matches found: rongg7@hpc3.rcic.uci.edu:~/Drosophila_genomes/w1118/assemblies/*
rongguo@Rongs-MacBook-Pro ~ % scp rongg7@hpc3.rcic.uci.edu:~/Drosophila_genomes/w1118/assemblies/*.fasta ~/Downloads
zsh: no matches found: rongg7@hpc3.rcic.uci.edu:~/Drosophila_genomes/w1118/assemblies/*.fasta
rongguo@Rongs-MacBook-Pro ~ % scp rongg7@hpc3.rcic.uci.edu:~//Drosophila_genomes/w1118/assemblies ~/Downloads 
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
scp: download Drosophila_genomes/w1118/assemblies/: not a regular file
rongguo@Rongs-MacBook-Pro ~ % scp rongg7@hpc3.rcic.uci.edu:~//Drosophila_genomes/w1118/assemblies/*.fasta ~/Downloads
zsh: no matches found: rongg7@hpc3.rcic.uci.edu:~//Drosophila_genomes/w1118/assemblies/*.fasta
rongguo@Rongs-MacBook-Pro ~ % scp rongg7@hpc3.rcic.uci.edu:~//Drosophila_genomes/w1118/assemblies/w1118.asm.fasta ~/Downloads
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
w1118.asm.fasta                                                                  100%  157MB  16.8MB/s   00:09    
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
Login timed out.

(rongg7@hpc3.rcic.uci.edu) Password: 
Connection closed by 128.200.221.16 port 22
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
Success. Logging you in...
+-----------------------------------------+
|  _             _             _ _  __    |
| | | ___   __ _(_)_ __       (_) |/ /_   |
| | |/ _ \ / _` | | '_ \ _____| | | '_ \  |
| | | (_) | (_| | | | | |_____| | | (_) | |
| |_|\___/ \__, |_|_| |_|     |_|_|\___/  |
|          |___/                          |
+-----------------------------------------+
 Distro:  Rocky 8.10 Green Obsidian
 Virtual: NO

 CPUs:    40
 RAM:     191.5GB
 BUILT:   2024-12-18 14:02

 RCIC WEBSITE: https://rcic.uci.edu
 ACCEPTABLE USE: https://rcic.uci.edu/account/acceptable-use.html
 SLURM GUIDE: https://rcic.uci.edu/slurm/slurm.html

 QUOTA ISSUES?: https://rcic.uci.edu/help/faq.html#disk-quotas

 HOLIDAY SUPPORT: 
     HPC3 Operational. Only Critical Ticket Support.
     https://rcic.uci.edu/about/news.html#news-events

Last failed login: Fri Dec 27 13:37:49 PST 2024 from 10.240.58.12 on ssh:notty
There was 1 failed login attempt since the last successful login.
Last login: Fri Dec 27 13:06:26 2024 from 10.240.58.12
(base) [rongg7@login-i16:~] $squeue -r rongg7
squeue: error: Unrecognized option: rongg7
Usage: squeue [-A account] [--clusters names] [-i seconds] [--job jobid]
              [-n name] [-o format] [--only-job-state] [-p partitions]
              [--qos qos] [--reservation reservation] [--sort fields] [--start]
              [--step step_id] [-t states] [-u user_name] [--usage]
              [-L licenses] [-w nodes] [--federation] [--local] [--sibling]
              [--expand-patterns] [--json=data_parser] [--yaml=data_parser]
              [-ahjlrsv]
(base) [rongg7@login-i16:~] $squeue -u rongg7
JOBID           PARTITION     NAME     USER    ACCOUNT ST        TIME  CPUS NODE NODELIST(REASON)
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta          a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
A3.Hifi.Scaf.relabel.fasta  a7.asm.relabel.fasta                    Ragout_relabel
A4.Hifi.Scaf.fasta          gfa_to_fasta.py                         run_sibeliaz.sh
A4.Hifi.Scaf.relabel.fasta  ISO1.Hifi.Scaf.fasta                    sibeliaz_out
a6.asm.bp.p_ctg.SCAF.fasta  ISO1.Hifi.Scaf.relabel.fasta            w1118
a6.asm.relabel.fasta        nohup.out                               w1118.filter.fastq
(base) [rongg7@login-i16:~/Drosophila_genomes] $cd ..
(base) [rongg7@login-i16:~] $ls
Drosophila_genomes  Drosophila_ref.fasta  GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna
(base) [rongg7@login-i16:~] $squeue -u rongg7
JOBID           PARTITION     NAME     USER    ACCOUNT ST        TIME  CPUS NODE NODELIST(REASON)
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta          a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout              slurm-35119299.out
A3.Hifi.Scaf.relabel.fasta  a7.asm.relabel.fasta                    Ragout_relabel      w1118
A4.Hifi.Scaf.fasta          gfa_to_fasta.py                         run_sibeliaz.sh     w1118.filter.fastq
A4.Hifi.Scaf.relabel.fasta  ISO1.Hifi.Scaf.fasta                    sibeliaz_nofil_out
a6.asm.bp.p_ctg.SCAF.fasta  ISO1.Hifi.Scaf.relabel.fasta            sibeliaz_out
a6.asm.relabel.fasta        nohup.out                               slurm-35119299.err
(base) [rongg7@login-i16:~/Drosophila_genomes] $ll
total 6097179
-rw-rw-r-- 1 rongg7 rongg7  174623702 Dec 20 13:04 A3.Hifi.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7  174624160 Dec 23 20:53 A3.Hifi.Scaf.relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7  172464929 Dec 20 13:04 A4.Hifi.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7  172465994 Dec 23 21:00 A4.Hifi.Scaf.relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7  176804740 Dec 20 13:04 a6.asm.bp.p_ctg.SCAF.fasta
-rw-rw-r-- 1 rongg7 rongg7  176805292 Dec 23 21:01 a6.asm.relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7  171849714 Dec 20 13:04 a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7  171850431 Dec 23 21:03 a7.asm.relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7       1027 Dec 24 11:53 gfa_to_fasta.py
-rw-rw-r-- 1 rongg7 rongg7  170697367 Dec 20 12:45 ISO1.Hifi.Scaf.fasta
-rw-rw-r-- 1 rongg7 rongg7  170698667 Dec 23 20:24 ISO1.Hifi.Scaf.relabel.fasta
-rw------- 1 rongg7 rongg7       1516 Dec 27 13:44 nohup.out
drwxrwxr-x 9 rongg7 rongg7         16 Dec 20 13:20 Ragout
drwxrwxr-x 2 rongg7 rongg7          7 Dec 23 21:09 Ragout_relabel
-rw-rw-r-- 1 rongg7 rongg7        660 Dec 27 13:40 run_sibeliaz.sh
drwxrwxr-x 2 rongg7 rongg7          3 Dec 26 13:21 sibeliaz_nofil_out
drwxrwxr-x 2 rongg7 rongg7          3 Dec 27 13:44 sibeliaz_out
-rw-rw-r-- 1 rongg7 rongg7       1173 Dec 27 13:40 slurm-35119299.err
-rw-rw-r-- 1 rongg7 rongg7         56 Dec 27 13:40 slurm-35119299.out
drwxrwxr-x 4 rongg7 rongg7         54 Dec 26 12:47 w1118
-rw-rw-r-- 1 rongg7 rongg7 8565780562 Dec 26 11:13 w1118.filter.fastq
(base) [rongg7@login-i16:~/Drosophila_genomes] $rm slurm-35119299.*
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta                      a7.asm.relabel.fasta          run_sibeliaz.sh
A3.Hifi.Scaf.relabel.fasta              gfa_to_fasta.py               sibeliaz_nofil_out
A4.Hifi.Scaf.fasta                      ISO1.Hifi.Scaf.fasta          sibeliaz_out
A4.Hifi.Scaf.relabel.fasta              ISO1.Hifi.Scaf.relabel.fasta  w1118
a6.asm.bp.p_ctg.SCAF.fasta              nohup.out                     w1118.filter.fastq
a6.asm.relabel.fasta                    Ragout
a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout_relabel
(base) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $ls
bin  build  docs  examples  LICENSE  Makefile  ragout  README.md  requirements.txt  scripts  setup.py
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $cd bin/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $nano recipe_file.txt
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout              ragout-overlap   run_sibeliaz.sh  sibeliaz_out        slurm-35093079.out
ragout-maf2synteny  recipe_file.txt  Sibelia          slurm-35093079.err
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $less slurm-35093079.err
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $cd sibeliaz_out/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/sibeliaz_out] $ls
alignment.maf  blocks_coords.gff
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/sibeliaz_out] $ll
total 132009
-rw-rw-r-- 1 rongg7 rongg7 292799261 Dec 24 11:53 alignment.maf
-rw-rw-r-- 1 rongg7 rongg7  36888378 Dec 24 11:41 blocks_coords.gff
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/sibeliaz_out] $cd ../..
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $;s
-bash: syntax error near unexpected token `;'
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $ls
bin  build  docs  examples  LICENSE  Makefile  ragout  README.md  requirements.txt  scripts  setup.py
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout] $cd bin
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout              ragout-overlap   run_sibeliaz.sh  sibeliaz_out        slurm-35093079.out
ragout-maf2synteny  recipe_file.txt  Sibelia          slurm-35093079.err
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout              ragout-overlap   run_sibeliaz.sh  sibeliaz_out        slurm-35093079.out
ragout-maf2synteny  recipe_file.txt  Sibelia          slurm-35093079.err
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls ../..
A3.Hifi.Scaf.fasta                      a7.asm.relabel.fasta          run_sibeliaz.sh
A3.Hifi.Scaf.relabel.fasta              gfa_to_fasta.py               sibeliaz_nofil_out
A4.Hifi.Scaf.fasta                      ISO1.Hifi.Scaf.fasta          sibeliaz_out
A4.Hifi.Scaf.relabel.fasta              ISO1.Hifi.Scaf.relabel.fasta  w1118
a6.asm.bp.p_ctg.SCAF.fasta              nohup.out                     w1118.filter.fastq
a6.asm.relabel.fasta                    Ragout
a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout_relabel
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $rm -r sibeliaz_out/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $rm slurm-35093079.*
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout -s maf --solid-scaffolds -t 8 -o output recipe_file.txt
Traceback (most recent call last):
  File "/data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/./ragout", line 31, in <module>
    from ragout.main import main
  File "/data/homezvol0/rongg7/Drosophila_genomes/Ragout/ragout/main.py", line 17, in <module>
    import ragout.assembly_graph.assembly_refine as asref
  File "/data/homezvol0/rongg7/Drosophila_genomes/Ragout/ragout/assembly_graph/assembly_refine.py", line 11, in <module>
    import networkx as nx
ModuleNotFoundError: No module named 'networkx'
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $module load miniconda3/2
ERROR: Unable to locate a modulefile for 'miniconda3/2'
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $module load miniconda3/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $conda activate myenv
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout -s maf --solid-scaffolds -t 8 -o output recipe_file.txt
[16:09:06] INFO: Starting Ragout v2.3
[16:09:07] INFO: Running withs synteny block sizes '[5000, 500, 100]'
[16:09:07] WARNING: Maf support is deprecated and will be removed in future releases. Use hal istead.
[16:09:07] INFO: Converting MAF to synteny
[16:09:07] INFO: Running maf2synteny module
	Reading maf file
	Started initial compression
	Simplification with 30 500
	Simplification with 100 5000
	Simplification with 500 50000
	Simplification with 5000 500000
[16:09:08] INFO: Inferring phylogeny from synteny blocks data
[16:09:08] INFO: Reading /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/output/maf-workdir/100/blocks_coords.txt
[16:09:08] ERROR: An error occured while running Ragout:
[16:09:08] ERROR: Permutations file is empty
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout --help
usage: ragout [-h] [-o output_dir] [-s {sibelia,maf,hal}] [--refine]
              [--solid-scaffolds] [--overwrite] [--repeats] [--debug]
              [-t THREADS] [--version]
              recipe_file

Chromosome assembly with multiple references

positional arguments:
  recipe_file           path to recipe file

optional arguments:
  -h, --help            show this help message and exit
  -o output_dir, --outdir output_dir
                        output directory (default: ragout-out)
  -s {sibelia,maf,hal}, --synteny {sibelia,maf,hal}
                        backend for synteny block decomposition (default:
                        sibelia)
  --refine              enable refinement with assembly graph (default: False)
  --solid-scaffolds     do not break input sequences - disables chimera
                        detection module (default: False)
  --overwrite           overwrite results from the previous run (default:
                        False)
  --repeats             enable repeat resolution algorithm (default: False)
  --debug               enable debug output (default: False)
  -t THREADS, --threads THREADS
                        number of threads for synteny backend (default: 1)
  --version             show program's version number and exit
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
output  ragout  ragout-maf2synteny  ragout-overlap  recipe_file.txt  run_sibeliaz.sh  Sibelia
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $cd output/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output] $ls
maf-workdir  ragout.log
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output] $cd maf-workdir/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output/maf-workdir] $ls
100  500  5000
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output/maf-workdir] $cd 100/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output/maf-workdir/100] $ls
blocks_coords.txt  coverage_report.txt  genomes_permutations.txt
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output/maf-workdir/100] $ll
total 2
-rw-rw-r-- 1 rongg7 rongg7 105 Dec 27 16:09 blocks_coords.txt
-rw-rw-r-- 1 rongg7 rongg7  81 Dec 27 16:09 coverage_report.txt
-rw-rw-r-- 1 rongg7 rongg7   0 Dec 27 16:09 genomes_permutations.txt
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/output/maf-workdir/100] $cd ../../..
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
output  ragout  ragout-maf2synteny  ragout-overlap  recipe_file.txt  run_sibeliaz.sh  Sibelia
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $cd ../..
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ll Ragout
Ragout/         Ragout_relabel/ 
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ll Ragout
Ragout/         Ragout_relabel/ 
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ll Ragout_relabel/
total 649298
-rw-rw-r-- 1 rongg7 rongg7 174623782 Dec 23 21:07 A3_relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7 172465217 Dec 23 21:07 A4_relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7 176804926 Dec 23 21:08 A6_relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7 171849966 Dec 23 21:09 A7_relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7 170697607 Dec 23 21:05 ISO_relabel.fasta
-rw-rw-r-- 1 rongg7 rongg7 164475024 Dec 27 15:46 w1118_relabel.fasta
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $awk '/^>/ {print ">scaffold." ++i; next} {print}' < ../GCF_000001215.4_Release_6_plus_ISO1_MT_genomic.fna > DroRef_relabel.fasta
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta                      a7.asm.relabel.fasta          Ragout_relabel
A3.Hifi.Scaf.relabel.fasta              DroRef_relabel.fasta          run_sibeliaz.sh
A4.Hifi.Scaf.fasta                      gfa_to_fasta.py               sibeliaz_nofil_out
A4.Hifi.Scaf.relabel.fasta              ISO1.Hifi.Scaf.fasta          sibeliaz_out
a6.asm.bp.p_ctg.SCAF.fasta              ISO1.Hifi.Scaf.relabel.fasta  w1118
a6.asm.relabel.fasta                    nohup.out                     w1118.filter.fastq
a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  Ragout
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout/
bin/      build/    docs/     examples/ .git/     ragout/   scripts/  
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout/
bin/      build/    docs/     examples/ .git/     ragout/   scripts/  
(myenv) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout/bin/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $nano recipe_file.txt 
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $rm -r output/
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout -s maf --solid-scaffolds -t 8 -o output recipe_file.txt
[16:28:47] INFO: Starting Ragout v2.3
[16:28:53] INFO: Running withs synteny block sizes '[5000, 500, 100]'
[16:28:53] WARNING: Maf support is deprecated and will be removed in future releases. Use hal istead.
[16:28:53] INFO: Converting MAF to synteny
[16:28:54] INFO: Running maf2synteny module
	Reading maf file
	Started initial compression
	Simplification with 30 500
	Simplification with 100 5000
	Simplification with 500 50000
	Simplification with 5000 500000
[16:29:08] INFO: Inferring phylogeny from synteny blocks data
[16:29:08] INFO: Reading /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/output/maf-workdir/100/blocks_coords.txt
[16:29:12] ERROR: An error occured while running Ragout:
[16:29:12] ERROR: Permutations file is empty
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $nano recipe_file.txt 
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout -s maf --solid-scaffolds -t 8 -o output recipe_file.txt
[16:39:49] INFO: Starting Ragout v2.3
[16:39:50] INFO: Running withs synteny block sizes '[5000, 500, 100]'
[16:39:50] WARNING: Maf support is deprecated and will be removed in future releases. Use hal istead.
[16:39:50] WARNING: Using synteny blocks from previous run
[16:39:50] WARNING: Use --overwrite to force alignment
[16:39:50] INFO: Inferring phylogeny from synteny blocks data
[16:39:50] INFO: Reading /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/output/maf-workdir/100/blocks_coords.txt
[16:39:50] ERROR: An error occured while running Ragout:
[16:39:50] ERROR: Permutations file is empty
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $./ragout -s maf --solid-scaffolds -t 8 -o output recipe_file.txt --overwrite
[16:45:00] INFO: Starting Ragout v2.3
[16:45:05] INFO: Running withs synteny block sizes '[5000, 500, 100]'
[16:45:05] WARNING: Maf support is deprecated and will be removed in future releases. Use hal istead.
[16:45:05] INFO: Converting MAF to synteny
[16:45:09] INFO: Running maf2synteny module
	Reading maf file
	Started initial compression
	Simplification with 30 500
	Simplification with 100 5000
	Simplification with 500 50000
	Simplification with 5000 500000
[16:45:12] INFO: Inferring phylogeny from synteny blocks data
[16:45:12] INFO: Reading /data/homezvol0/rongg7/Drosophila_genomes/Ragout/bin/output/maf-workdir/100/blocks_coords.txt
[16:45:12] ERROR: An error occured while running Ragout:
[16:45:12] ERROR: Permutations file is empty
(myenv) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $Read from remote host hpc3.rcic.uci.edu: Connection reset by peer
Connection to hpc3.rcic.uci.edu closed.
client_loop: send disconnect: Broken pipe
rongguo@Rongs-MacBook-Pro ~ % scp ~/Downloads/mega-cc_11.0.13-1_amd64.deb rongg7@hpc3.rcic.uci.edu:~
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
mega-cc_11.0.13-1_amd64.deb                                                      100%  122MB   2.3MB/s   00:51    
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu                                          
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
Success. Logging you in...
+-----------------------------------------+
|  _             _             _ _  __    |
| | | ___   __ _(_)_ __       (_) |/ /_   |
| | |/ _ \ / _` | | '_ \ _____| | | '_ \  |
| | | (_) | (_| | | | | |_____| | | (_) | |
| |_|\___/ \__, |_|_| |_|     |_|_|\___/  |
|          |___/                          |
+-----------------------------------------+
 Distro:  Rocky 8.10 Green Obsidian
 Virtual: NO

 CPUs:    40
 RAM:     191.5GB
 BUILT:   2024-12-18 14:02

 RCIC WEBSITE: https://rcic.uci.edu
 ACCEPTABLE USE: https://rcic.uci.edu/account/acceptable-use.html
 SLURM GUIDE: https://rcic.uci.edu/slurm/slurm.html

 QUOTA ISSUES?: https://rcic.uci.edu/help/faq.html#disk-quotas

Last login: Mon Jan  6 11:59:28 2025 from 10.240.58.12
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/
(base) [rongg7@login-i16:~/Drosophila_genomes] $ls
A3.Hifi.Scaf.fasta          a7.asm.bp.p_ctg.ContMitoRem.Scaf.fasta  nohup.out
A3.Hifi.Scaf.relabel.fasta  a7.asm.relabel.fasta                    Ragout
A4.Hifi.Scaf.fasta          DroRef_relabel.fasta                    Ragout_relabel
A4.Hifi.Scaf.relabel.fasta  gfa_to_fasta.py                         run_sibeliaz.sh
a6.asm.bp.p_ctg.SCAF.fasta  ISO1.Hifi.Scaf.fasta                    w1118
a6.asm.relabel.fasta        ISO1.Hifi.Scaf.relabel.fasta            w1118.filter.fastq
(base) [rongg7@login-i16:~/Drosophila_genomes] $cd Ragout/bin/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout  ragout-maf2synteny  ragout-overlap  ragtag_output  recipe_file_1.txt
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $cd ragtag_output/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/ragtag_output] $ls
compleasm.err        ragtag.scaffold.asm.paf         ragtag.scaffold.fasta   w1118_ref.fasta.dict
compleasm.out        ragtag.scaffold.asm.paf.log     ragtag.scaffold.stats   w1118_ref.fasta.prep
compleasm.sh         ragtag.scaffold.confidence.txt  w1118_ref.fasta         w1118_ref.fasta.prep.bak
ragtag.scaffold.agp  ragtag.scaffold.err             w1118_ref.fasta.bak.gz
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/ragtag_output] $cd ~/
.cache/               Drosophila_genomes/   .java/                megacc_11.0.13_amd64/ .ssh/
.conda/               earlgrey_output/      .local/               Reference/            
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/ragtag_output] $cd ~/earlgrey_output/
(base) [rongg7@login-i16:~/earlgrey_output] $ls
 Drosophila_EarlGrey
(base) [rongg7@login-i16:~/earlgrey_output] $cd Drosophila_EarlGrey/
(base) [rongg7@login-i16:~/earlgrey_output/Drosophila_EarlGrey] $ls
Drosophila_Curated_Library  Drosophila_mergedRepeats                        Drosophila_RepeatModeler
Drosophila_Database         Drosophila_RepeatLandscape                      Drosophila_strainer
DrosophilaEarlGrey.log      Drosophila_RepeatMasker                         Drosophila_summaryFiles
Drosophila_heliano          Drosophila_RepeatMasker_Against_Custom_Library
(base) [rongg7@login-i16:~/earlgrey_output/Drosophila_EarlGrey] $tail DrosophilaEarlGrey.log 
       93% completed,  08:10:30 (hh:mm:ss) est. time remaining.
       93% completed,  08:9:00 (hh:mm:ss) est. time remaining.
       93% completed,  08:7:23 (hh:mm:ss) est. time remaining.
       93% completed,  08:5:45 (hh:mm:ss) est. time remaining.
       93% completed,  08:4:16 (hh:mm:ss) est. time remaining.
       93% completed,  08:2:40 (hh:mm:ss) est. time remaining.
       93% completed,  08:1:04 (hh:mm:ss) est. time remaining.
       93% completed,  07:59:36 (hh:mm:ss) est. time remaining.
       93% completed,  07:58:09 (hh:mm:ss) est. time remaining.
       93% completed,  07:56:40 (hh:mm:ss) est. time remaining.
(base) [rongg7@login-i16:~/earlgrey_output/Drosophila_EarlGrey] $tail DrosophilaEarlGrey.log 
       93% completed,  08:9:00 (hh:mm:ss) est. time remaining.
       93% completed,  08:7:23 (hh:mm:ss) est. time remaining.
       93% completed,  08:5:45 (hh:mm:ss) est. time remaining.
       93% completed,  08:4:16 (hh:mm:ss) est. time remaining.
       93% completed,  08:2:40 (hh:mm:ss) est. time remaining.
       93% completed,  08:1:04 (hh:mm:ss) est. time remaining.
       93% completed,  07:59:36 (hh:mm:ss) est. time remaining.
       93% completed,  07:58:09 (hh:mm:ss) est. time remaining.
       93% completed,  07:56:40 (hh:mm:ss) est. time remaining.
       93% completed,  07:55:12 (hh:mm:ss) est. time remaining.
(base) [rongg7@login-i16:~/earlgrey_output/Drosophila_EarlGrey] $Read from remote host hpc3.rcic.uci.edu: Connection reset by peer
Connection to hpc3.rcic.uci.edu closed.
client_loop: send disconnect: Broken pipe
rongguo@Rongs-MacBook-Pro ~ % ssh rongg7@hpc3.rcic.uci.edu
(rongg7@hpc3.rcic.uci.edu) Password: 
(rongg7@hpc3.rcic.uci.edu) Duo two-factor login for rongg7

Enter a passcode or select one of the following options:

 1. Duo Push to XXX-XXX-8555

Passcode or option (1-1): 1
Success. Logging you in...
+-----------------------------------------+
|  _             _             _ _  __    |
| | | ___   __ _(_)_ __       (_) |/ /_   |
| | |/ _ \ / _` | | '_ \ _____| | | '_ \  |
| | | (_) | (_| | | | | |_____| | | (_) | |
| |_|\___/ \__, |_|_| |_|     |_|_|\___/  |
|          |___/                          |
+-----------------------------------------+
 Distro:  Rocky 8.10 Green Obsidian
 Virtual: NO

 CPUs:    40
 RAM:     191.5GB
 BUILT:   2024-12-18 14:02

 RCIC WEBSITE: https://rcic.uci.edu
 ACCEPTABLE USE: https://rcic.uci.edu/account/acceptable-use.html
 SLURM GUIDE: https://rcic.uci.edu/slurm/slurm.html

 QUOTA ISSUES?: https://rcic.uci.edu/help/faq.html#disk-quotas

Last login: Mon Jan  6 14:02:32 2025 from 10.240.58.12
(base) [rongg7@login-i16:~] $locate busco_lineage
(base) [rongg7@login-i16:~] $cd Drosophila_genomes/Ragout/bin/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $ls
ragout  ragout-maf2synteny  ragout-overlap  ragtag_output  recipe_file_1.txt
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin] $cd ragtag_output/
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/ragtag_output] $ls
compleasm.err        ragtag.scaffold.asm.paf         ragtag.scaffold.stats   w1118_ref.fasta.prep
compleasm.out        ragtag.scaffold.asm.paf.log     w1118_compleasm         w1118_ref.fasta.prep.bak
compleasm.sh         ragtag.scaffold.confidence.txt  w1118_ref.fasta
mb_downloads         ragtag.scaffold.err             w1118_ref.fasta.bak.gz
ragtag.scaffold.agp  ragtag.scaffold.fasta           w1118_ref.fasta.dict
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/ragtag_output] $ll
total 430809
-rw-rw-r-- 1 rongg7 rongg7      2031 Jan  6 15:42 compleasm.err
-rw-rw-r-- 1 rongg7 rongg7       680 Jan  6 15:42 compleasm.out
-rw-rw-r-- 1 rongg7 rongg7       921 Jan  6 15:38 compleasm.sh
drwxrwxr-x 5 rongg7 rongg7        13 Jan  6 15:32 mb_downloads
-rw-rw-r-- 1 rongg7 rongg7     11403 Dec 30 12:05 ragtag.scaffold.agp
-rw-rw-r-- 1 rongg7 rongg7   1265524 Dec 30 12:05 ragtag.scaffold.asm.paf
-rw-rw-r-- 1 rongg7 rongg7       770 Dec 30 12:05 ragtag.scaffold.asm.paf.log
-rw-rw-r-- 1 rongg7 rongg7      2405 Dec 30 12:05 ragtag.scaffold.confidence.txt
-rw-rw-r-- 1 rongg7 rongg7         0 Dec 30 11:58 ragtag.scaffold.err
-rw-rw-r-- 1 rongg7 rongg7 161783027 Dec 30 12:05 ragtag.scaffold.fasta
-rw-rw-r-- 1 rongg7 rongg7       112 Dec 30 12:05 ragtag.scaffold.stats
drwxrwxr-x 3 rongg7 rongg7         4 Jan  6 15:42 w1118_compleasm
-rw-rw-r-- 1 rongg7 rongg7 151137338 Dec 30 15:07 w1118_ref.fasta
-rw-rw-r-- 1 rongg7 rongg7  40371126 Dec 30 15:09 w1118_ref.fasta.bak.gz
-rw-rw-r-- 1 rongg7 rongg7       217 Dec 30 15:10 w1118_ref.fasta.dict
-rw-rw-r-- 1 rongg7 rongg7 151137206 Dec 30 15:10 w1118_ref.fasta.prep
-rw-rw-r-- 1 rongg7 rongg7 151137206 Dec 30 15:10 w1118_ref.fasta.prep.bak
(base) [rongg7@login-i16:~/Drosophila_genomes/Ragout/bin/ragtag_output] $less compleasm.sh

## Specify the job name
#SBATCH --job-name=compleasm

## account to charge
#SBATCH -A grylee_lab 

# Define nodes tasks and cpu_per_task
#SBATCH --nodes=1            ## (-N) number of nodes to use
#SBATCH --ntasks=1           ## (-n) number of tasks to launch
#SBATCH --cpus-per-task=16    ## number of cores the job needs

## Specify which queues you want to submit the jobs too
#SBATCH -p standard

# Specify where standard output and error are stored
#SBATCH --error=compleasm.err
#SBATCH --output=compleasm.out

# Pass the current environment variables
#SBATCH --export=ALL

# Go to current working directory 
#SBATCH --chdir=.

## LOAD MODULES or ENVIRONMENTS  ##

source /opt/apps/miniconda3/23.5.2/etc/profile.d/conda.sh
conda activate compleasm
## conda install -c bioconda compleasm

ASM=w1118_ref.fasta
compleasm run -a $ASM -o w1118_compleasm -t 16 -l diptera

## The completeness was measured as below:
## lineage: diptera_odb10
## S:99.73%, 3276
## D:0.24%, 8
## F:0.00%, 0
## I:0.00%, 0
## M:0.03%, 1
## N:3285

