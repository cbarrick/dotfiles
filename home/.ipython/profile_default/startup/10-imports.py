from copy import copy, deepcopy
from importlib import reload
from pathlib import Path
import math

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
