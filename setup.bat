@echo off
setlocal enabledelayedexpansion

:: Create virtual environment if it doesn't exist
if not exist ".venv\" (
    echo Creating virtual environment...
    python -m venv .venv
    
    :: Check if venv creation was successful
    if not exist ".venv\" (
        echo Error: Failed to create virtual environment
        exit /b 1
    )
)

:: Activate virtual environment
echo Activating virtual environment...
call .venv\Scripts\activate.bat

:: Install dependencies
echo Installing dependencies...
pip install -r requirements.txt

:: Generate a random secret key for Flask
for /f "tokens=*" %%a in ('python -c "import secrets; print(secrets.token_hex(16))"') do set SECRET_KEY=%%a

:: Create .env file if it doesn't exist
if not exist ".env" (
    echo Creating .env file...
    (
        echo SECRET_KEY=!SECRET_KEY!
        echo OLLAMA_API_URL=http://localhost:11434/api
    ) > .env
    echo .env file created with a random secret key
) else (
    echo .env file already exists
)

echo.
echo Setup complete! You can now run the application with:
echo .venv\Scripts\activate.bat ^&^& python app.py
echo.
echo Then visit http://127.0.0.1:5000 in your browser

pause
