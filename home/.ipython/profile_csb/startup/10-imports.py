import math
import os
import sys
from copy import copy, deepcopy
from pathlib import Path

# Deep reload is currently broken:
# https://github.com/ipython/ipython/issues/14570
# from IPython.lib.deepreload import reload
from importlib import reload

try:
    import numpy as np
except ImportError:
    pass

try:
    import pandas as pd
except ImportError:
    pass

try:
    import scipy
except ImportError:
    pass

try:
    import jax
    import jax.numpy as jnp
except ImportError:
    pass
