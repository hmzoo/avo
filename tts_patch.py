"""
Patch pour TTS afin de résoudre le problème weights_only avec PyTorch 2.6+
"""
import torch
import torch.serialization
from TTS.tts.configs.xtts_config import XttsConfig

# Ajouter XttsConfig comme classe sûre pour torch.load
torch.serialization.add_safe_globals([XttsConfig])

# Patch de la fonction load_fsspec pour forcer weights_only=False
from TTS.utils import io
original_load_fsspec = io.load_fsspec

def patched_load_fsspec(path, map_location=None, cache=True, **kwargs):
    """Version patchée qui force weights_only=False pour la compatibilité"""
    kwargs['weights_only'] = False
    return original_load_fsspec(path, map_location, cache, **kwargs)

io.load_fsspec = patched_load_fsspec

print("✅ Patch TTS appliqué pour PyTorch 2.6+")
