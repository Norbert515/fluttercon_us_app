# 🚀 Deployment to GitHub Pages

This Flutter app is configured to automatically deploy to GitHub Pages using GitHub Actions.

## 📋 Setup Instructions

### 1. Enable GitHub Pages

1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select **GitHub Actions**
4. Save the settings

### 2. Configure Repository Permissions

1. In your repository, go to **Settings** → **Actions** → **General**
2. Under **Workflow permissions**, ensure **Read and write permissions** is selected
3. Check **Allow GitHub Actions to create and approve pull requests**
4. Save the settings

### 3. Push to Main Branch

The workflow will automatically trigger when you:
- Push commits to the `main` branch
- Create a pull request to `main`
- Manually trigger it from the Actions tab

## 🔧 Workflow Details

The deployment process includes:

- **Code checkout** and repository setup
- **Flutter setup** using Flutter 3.27.0 stable channel
- **Dependency installation** using `flutter pub get`
- **Code analysis** to check for issues
- **Test execution** to ensure quality
- **Web build** with proper base href for GitHub Pages
- **Automatic deployment** to GitHub Pages

## 🌐 Access Your App

After successful deployment, your app will be available at:
```
https://<your-username>.github.io/fluttercon_app/
```

Replace `<your-username>` with your actual GitHub username.

## 🛠️ Local Development

### Option 1: Standard Flutter (Recommended for deployment consistency)

```bash
# Ensure you have Flutter 3.27.0 installed
flutter --version

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome

# Build for web
flutter build web
```

### Option 2: Using FVM (Optional)

If you prefer to use FVM for version management:

```bash
# Install FVM globally
dart pub global activate fvm

# Install the Flutter version specified in .fvmrc
fvm install

# Use the specified version
fvm use

# Run commands with FVM
fvm flutter pub get
fvm flutter run -d chrome
fvm flutter build web
```

## 📝 Workflow Configuration

The workflow is configured in `.github/workflows/deploy.yml` and includes:

- **Triggers**: Push to main, PR to main, manual dispatch
- **Flutter Version**: Locked to 3.27.0 stable channel
- **Base Href**: Configured for GitHub Pages subdirectory
- **Web Renderer**: HTML renderer for better compatibility
- **Caching**: Dependencies and Flutter SDK are cached for faster builds

## 🔍 Monitoring Deployments

You can monitor deployment status:

1. Go to the **Actions** tab in your repository
2. Check the latest workflow run
3. View logs for any errors or issues
4. The deployment URL will be shown in the deploy job

## ⚠️ Important Notes

- **First deployment** may take 5-10 minutes to be accessible
- **DNS propagation** can take additional time
- **Asset loading** ensure all assets are included in the `web/` folder
- **Routing** Flutter web handles client-side routing automatically

## 🐛 Troubleshooting

### Build Failures
- Check the Actions logs for specific error messages
- Ensure all tests pass locally before pushing
- Verify Flutter version compatibility (3.27.0 recommended)

### Assets Not Loading
- Ensure assets are properly declared in `pubspec.yaml`
- Check that asset paths are correct for web deployment
- Verify base href configuration in build command

### Page Not Accessible
- Confirm GitHub Pages is enabled in repository settings
- Wait 5-10 minutes after first deployment
- Check if custom domain settings are interfering

## 🎉 Features in Production

Your deployed FlutterCon app includes:
- ✅ Session favoriting with local storage persistence
- ✅ Animated UI interactions
- ✅ Responsive design for mobile and desktop
- ✅ Fast loading with optimized web build
- ✅ Progressive Web App capabilities 