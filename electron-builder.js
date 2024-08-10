function ensureEnvVar(envVarName) {
  if (!(envVarName in process.env)) {
    throw new Error(`Missing environment variable ${envVarName}`);
  }

  return process.env[envVarName];
}

const editionEnvVar = ensureEnvVar('NOTION_REPACKAGED_EDITION'),
  versionEnvVar = ensureEnvVar('NOTION_VERSION'),
  revisionEnvVar = ensureEnvVar('NOTION_REPACKAGED_REVISION');

const isVanilla = editionEnvVar === 'vanilla';

const productName = 'Notion',
  productId = 'notion-app',
  conflictProductId = 'notion-app-enhanced',
  productDescription = 'The all-in-one workspace for your notes and tasks';

const fpmOptions = [
  `--version=${versionEnvVar}`,
  `--iteration=${revisionEnvVar}`,
  `--conflicts=${conflictProductId}`,
];

const combineTargetAndArch = (targets, architectures = ['x64', 'arm64']) =>
  targets.map((target) => ({ target, arch: architectures }));

// realistically Auto Update only works for Windows
const getPublishProviders = (platform) => [
  {
    provider: 'github',
    publishAutoUpdate: platform === 'win',
  },
];

module.exports = {
  asar: true,
  productName: productName,
  extraMetadata: {
    description: productDescription,
  },
  appId: 'com.github.notion-repackaged',
  protocols: [{ name: 'Notion', schemes: ['notion'] }],
  linux: {
    icon: 'icon.icns',
    category: 'Office;Utility;',
    maintainer: 'jaime@jamezrin.name',
    mimeTypes: ['x-scheme-handler/notion'],
    desktop: {
      StartupNotify: 'true',
      StartupWMClass: productId,
    },
    target: combineTargetAndArch(['AppImage']),
    publish: getPublishProviders('linux'),
  }
};
