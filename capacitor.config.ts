import type { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.thexmr.clipcomplete',
  appName: 'ClipComplete',
  webDir: 'www',
  server: {
    // Erlaubt HTTP zum Studio-Server im Heimnetz (z.B. http://192.168.1.20:8000).
    // Fuer einen oeffentlichen Server spaeter HTTPS verwenden und dies entfernen.
    androidScheme: 'http',
    cleartext: true,
  },
};

export default config;
