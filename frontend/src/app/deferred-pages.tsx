import { lazy, Suspense, type ComponentType, type LazyExoticComponent } from "react";

import { Spinner } from "@/components/ui/spinner";

const AccountsPage = lazyNamed(() => import("@/features/accounts/accounts-page"), "AccountsPage");
const AppShell = lazyNamed(() => import("@/app/app-shell"), "AppShell");
const RequestAuditsPage = lazyNamed(() => import("@/features/audits/request-audits-page"), "RequestAuditsPage");
const ClientKeysPage = lazyNamed(() => import("@/features/client-keys/client-keys-page"), "ClientKeysPage");
const CreativeConsolePage = lazyNamed(() => import("@/features/creative-console/creative-console-page"), "CreativeConsolePage");
const DashboardPage = lazyNamed(() => import("@/features/dashboard/dashboard-page"), "DashboardPage");
const ApiDocsPage = lazyNamed(() => import("@/features/docs/api-docs-page"), "ApiDocsPage");
const GalleryPage = lazyNamed(() => import("@/features/media/gallery-page"), "GalleryPage");
const VideoGalleryPage = lazyNamed(() => import("@/features/media/video-gallery-page"), "VideoGalleryPage");
const ModelsPage = lazyNamed(() => import("@/features/models/models-page"), "ModelsPage");
const SettingsPage = lazyNamed(() => import("@/features/settings/settings-page"), "SettingsPage");

function lazyNamed<T extends Record<K, ComponentType>, K extends keyof T>(loader: () => Promise<T>, exportName: K): LazyExoticComponent<T[K]> {
  return lazy(async () => {
    try {
      const module = await loader();
      if (typeof window !== "undefined") window.sessionStorage.removeItem("grok2api:chunk-reload");
      return { default: module[exportName] };
    } catch (error) {
      // Setelah deployment, browser kadang masih menyimpan manifest lama dan
      // gagal mengambil chunk halaman baru. Pulihkan otomatis sekali, sehingga
      // pengguna tidak perlu menekan refresh secara manual.
      if (typeof window !== "undefined") {
        const reloadKey = "grok2api:chunk-reload";
        if (!window.sessionStorage.getItem(reloadKey)) {
          window.sessionStorage.setItem(reloadKey, "1");
          window.location.reload();
          return new Promise<never>(() => undefined);
        }
        window.sessionStorage.removeItem(reloadKey);
      }
      throw error;
    }
  });
}

function DeferredPage({ page: Page }: { page: ComponentType }) {
  return <Suspense fallback={<PageLoadingFallback />}><Page /></Suspense>;
}

export function DeferredAccountsPage() {
  return <DeferredPage page={AccountsPage} />;
}

export function DeferredAppShell() {
  return <Suspense fallback={<PageLoadingFallback fullScreen />}><AppShell /></Suspense>;
}

export function DeferredDashboardPage() {
  return <DeferredPage page={DashboardPage} />;
}

export function DeferredModelsPage() {
  return <DeferredPage page={ModelsPage} />;
}

export function DeferredClientKeysPage() {
  return <DeferredPage page={ClientKeysPage} />;
}

export function DeferredCreativeConsolePage() {
  return <DeferredPage page={CreativeConsolePage} />;
}

export function DeferredRequestAuditsPage() {
  return <DeferredPage page={RequestAuditsPage} />;
}

export function DeferredGalleryPage() {
  return <DeferredPage page={GalleryPage} />;
}

export function DeferredVideoGalleryPage() {
  return <DeferredPage page={VideoGalleryPage} />;
}

export function DeferredApiDocsPage() {
  return <DeferredPage page={ApiDocsPage} />;
}

export function DeferredSettingsPage() {
  return <DeferredPage page={SettingsPage} />;
}

function PageLoadingFallback({ fullScreen = false }: { fullScreen?: boolean }) {
  return (
    <div className={fullScreen ? "flex min-h-screen items-center justify-center bg-background" : "flex min-h-[calc(100vh-7rem)] items-center justify-center lg:min-h-[calc(100vh-10rem)]"}>
      <Spinner className="size-5" />
    </div>
  );
}
