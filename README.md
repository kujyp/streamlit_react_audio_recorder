# streamlit-react-audio-recorder

Streamlit react audio recorder component

## Installation instructions

```sh
pip install streamlit-react-audio-recorder
```

## Usage instructions

```python
import streamlit as st

from streamlit_react_audio_recorder import streamlit_react_audio_recorder

value = streamlit_react_audio_recorder()

st.write(value)
```

## Development
### Run
- Run frontend 3001 Port
```bash
cd streamlit_react_audio_recorder/frontend
yarn install
yarn run start
```
- Run streamlit 8501 Port
```bash
python -m venv venv
source venv/bin/activate

poetry install --no-root
PYTHONPATH='.' streamlit run streamlit_react_audio_recorder/example.py
```

### Tests
- Run frontend 3001 Port
```bash
cd streamlit_react_audio_recorder/frontend
yarn install
yarn run start
```
- Run playwright test
```bash
python -m venv venv
source venv/bin/activate

poetry install --no-root
playwright install
pytest -vvv e2e
```

### Tests-docker
```bash
docker build --target e2e -t streamlit-react-audio-recorder:dev-e2e .
docker run -it --rm streamlit-react-audio-recorder:dev-e2e
```
