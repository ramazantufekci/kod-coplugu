Tamam — bütün proje dosyalarının **tam kodlarını** tek mesajta veriyorum. Aşağıdaki yapıyı olduğu gibi kopyala/yapıştır ile kendi makinenizde aynı klasör/ dosya isimleriyle oluşturabilirsiniz.

> Not: dosya adlarını ve klasörleri birebir kullanın. Büyük projelerde `mkdir -p` ile dizinleri oluşturup, dosyaları uygun yerlerde `cat > file <<'EOF' ... EOF` şeklinde yazdırabilirsiniz.

---

# Proje kökü: `gobiz-vcard-saas-starter`

## 1) `docker-compose.yml`

```yaml
services:
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: gobiz
    ports:
      - "5432:5432"
    volumes:
      - dbdata:/var/lib/postgresql/data

  backend:
    build: ./backend
    command: sh -c "npm run prisma:dev && npm run dev"
    environment:
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/gobiz?schema=public
      - JWT_SECRET=dev
      - PORT=4000
      - CORS_ORIGIN=http://localhost:3000
      - PUBLIC_BASE_URL=http://localhost:3000
    depends_on:
      - db
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app

  frontend:
    build: ./frontend
    command: npm run dev
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:4000
    depends_on:
      - backend
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app

volumes:
  dbdata:
```

---

## 2) `README.md`

````markdown
# GoBiz-like vCard SaaS Starter

Açık kaynak, modüler bir başlangıç projesi. GoBiz'e benzer ana özellikler:
- Çoklu kullanıcı, JWT ile kimlik doğrulama
- vCard kartı oluşturma / düzenleme
- Her kart için benzersiz `slug` ve herkese açık profil sayfası `/p/:slug`
- QR kod üretimi (PNG)
- Basit analiz: görüntülenme kayıtları

## Hızlı Başlangıç (Docker Compose)
```bash
docker compose up
````

## Manuel Kurulum

### Backend

```bash
cd backend
cp .env.example .env
npm i
npm run prisma:dev
npm run dev
```

### Frontend

```bash
cd frontend
npm i
npm run dev
# http://localhost:3000
```

## API Kısa Özet

* `POST /auth/register` `{ email, password, name? }`
* `POST /auth/login` => `{ token }`
* `GET /cards` (auth)
* `POST /cards` (auth) body: `{ slug, fullName, ... }`
* `GET /cards/:id/qr` (auth) => PNG
* `GET /p/:slug` (public json)
* `POST /p/:slug/view` (public; görüntülenme kaydı)

> Not: Bu proje örnek bir iskelettir. Ücretlendirme/SaaS katmanı, tema editörü, çoklu şablon, ekip/kurumsal, i18n, webhooks, admin paneli, dosya yükleme, ödeme (Stripe/Iyzico) gibi özellikler için genişletin.

````

---

# Backend dosyaları (`backend/`)

### 3) `backend/package.json`
```json
{
  "name": "gobiz-vcard-backend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "prisma:dev": "prisma migrate dev --name init && prisma generate",
    "prisma:generate": "prisma generate"
  },
  "dependencies": {
    "@prisma/client": "^5.17.0",
    "bcryptjs": "^2.4.3",
    "cors": "^2.8.5",
    "dotenv": "^16.4.5",
    "express": "^4.19.2",
    "helmet": "^7.1.0",
    "jsonwebtoken": "^9.0.2",
    "morgan": "^1.10.0",
    "qrcode": "^1.5.3",
    "zod": "^3.23.8"
  },
  "devDependencies": {
    "prisma": "^5.17.0",
    "ts-node": "^10.9.2",
    "tsx": "^4.16.2",
    "typescript": "^5.5.4"
  }
}
````

### 4) `backend/tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "ES2020",
    "moduleResolution": "node",
    "rootDir": "src",
    "outDir": "dist",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true
  },
  "include": ["src"]
}
```

### 5) `backend/.env.example`

```
# Copy to .env and adjust
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/gobiz?schema=public"
JWT_SECRET="change_me"
PORT=4000
CORS_ORIGIN=http://localhost:3000
PUBLIC_BASE_URL=http://localhost:3000
```

### 6) `backend/Dockerfile`

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./
RUN npm install || true
COPY . .
EXPOSE 4000
CMD ["npm","run","dev"]
```

### 7) `backend/prisma/schema.prisma`

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  password  String
  name      String?
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  cards     Card[]
}

model Card {
  id        String   @id @default(cuid())
  ownerId   String
  owner     User     @relation(fields: [ownerId], references: [id])
  slug      String   @unique
  fullName  String
  title     String?
  company   String?
  email     String?
  phone     String?
  website   String?
  bio       String?
  avatarUrl String?
  theme     String   @default("classic")
  socials   Json     @default("{}")
  views     ViewEvent[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}

model ViewEvent {
  id        String   @id @default(cuid())
  cardId    String
  card      Card     @relation(fields: [cardId], references: [id])
  userAgent String?
  referrer  String?
  ipHash    String?
  createdAt DateTime @default(now())
}
```

### 8) `backend/src/index.ts`

```ts
import 'dotenv/config'
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import morgan from 'morgan'
import { PrismaClient } from '@prisma/client'
import authRoutes from './routes/auth.js'
import cardRoutes from './routes/cards.js'
import publicRoutes from './routes/public.js'

const app = express()
const prisma = new PrismaClient()

const PORT = process.env.PORT || 4000
const ORIGIN = process.env.CORS_ORIGIN || 'http://localhost:3000'

app.use(helmet())
app.use(cors({ origin: ORIGIN, credentials: true }))
app.use(express.json({ limit: '1mb' }))
app.use(morgan('dev'))

app.get('/health', (_req, res) => res.json({ ok: true }))

app.use('/auth', authRoutes(prisma))
app.use('/cards', cardRoutes(prisma))
app.use('/p', publicRoutes(prisma))

app.use((err:any, _req:any, res:any, _next:any) => {
  console.error(err)
  res.status(err.status || 500).json({ error: err.message || 'Server error' })
})

app.listen(PORT, () => console.log(`API listening on :${PORT}`))
```

### 9) `backend/src/middleware/auth.ts`

```ts
import { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'

export interface AuthedRequest extends Request {
  user?: { id: string, email: string }
}

export const requireAuth = (req: AuthedRequest, res: Response, next: NextFunction) => {
  const header = req.headers.authorization
  if (!header?.startsWith('Bearer ')) return res.status(401).json({ error: 'Missing token' })
  const token = header.split(' ')[1]
  try {
    const secret = process.env.JWT_SECRET || 'dev'
    const payload = jwt.verify(token, secret) as any
    req.user = { id: payload.sub, email: payload.email }
    next()
  } catch (e) {
    return res.status(401).json({ error: 'Invalid token' })
  }
}
```

### 10) `backend/src/routes/auth.ts`

```ts
import { Router } from 'express'
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'

export default function authRoutes(prisma: PrismaClient) {
  const r = Router()

  r.post('/register', async (req, res) => {
    const { email, password, name } = req.body || {}
    if (!email || !password) return res.status(400).json({ error: 'email and password required' })
    const hash = await bcrypt.hash(password, 10)
    try {
      const user = await prisma.user.create({ data: { email, password: hash, name } })
      return res.json({ id: user.id, email: user.email })
    } catch (e:any) {
      if (e.code === 'P2002') return res.status(409).json({ error: 'Email already in use' })
      throw e
    }
  })

  r.post('/login', async (req, res) => {
    const { email, password } = req.body || {}
    if (!email || !password) return res.status(400).json({ error: 'email and password required' })
    const user = await prisma.user.findUnique({ where: { email } })
    if (!user) return res.status(401).json({ error: 'Invalid credentials' })
    const ok = await bcrypt.compare(password, user.password)
    if (!ok) return res.status(401).json({ error: 'Invalid credentials' })
    const secret = process.env.JWT_SECRET || 'dev'
    const token = jwt.sign({ sub: user.id, email: user.email }, secret, { expiresIn: '7d' })
    res.json({ token, user: { id: user.id, email: user.email, name: user.name } })
  })

  return r
}
```

### 11) `backend/src/routes/cards.ts`

```ts
import { Router } from 'express'
import { PrismaClient } from '@prisma/client'
import { requireAuth, AuthedRequest } from '../middleware/auth.js'
import QRCode from 'qrcode'

export default function cardRoutes(prisma: PrismaClient) {
  const r = Router()

  r.get('/', requireAuth, async (req: AuthedRequest, res) => {
    const cards = await prisma.card.findMany({ where: { ownerId: req.user!.id } })
    res.json(cards)
  })

  r.post('/', requireAuth, async (req: AuthedRequest, res) => {
    const { slug, fullName, title, company, email, phone, website, bio, avatarUrl, theme, socials } = req.body
    if (!slug || !fullName) return res.status(400).json({ error: 'slug and fullName required' })
    try {
      const card = await prisma.card.create({
        data: {
          slug, fullName, title, company, email, phone, website, bio, avatarUrl, theme,
          socials, ownerId: req.user!.id
        }
      })
      res.status(201).json(card)
    } catch (e:any) {
      if (e.code === 'P2002') return res.status(409).json({ error: 'Slug already in use' })
      throw e
    }
  })

  r.get('/:id', requireAuth, async (req: AuthedRequest, res) => {
    const card = await prisma.card.findFirst({ where: { id: req.params.id, ownerId: req.user!.id } })
    if (!card) return res.status(404).json({ error: 'Not found' })
    res.json(card)
  })

  r.put('/:id', requireAuth, async (req: AuthedRequest, res) => {
    const card = await prisma.card.update({
      where: { id: req.params.id },
      data: req.body
    })
    res.json(card)
  })

  r.delete('/:id', requireAuth, async (req: AuthedRequest, res) => {
    await prisma.card.delete({ where: { id: req.params.id } })
    res.status(204).end()
  })

  r.get('/:id/qr', requireAuth, async (req: AuthedRequest, res) => {
    const card = await prisma.card.findFirst({ where: { id: req.params.id, ownerId: req.user!.id } })
    if (!card) return res.status(404).json({ error: 'Not found' })
    const url = `${process.env.PUBLIC_BASE_URL || 'http://localhost:3000'}/p/${card.slug}`
    const png = await QRCode.toBuffer(url, { type: 'png', width: 512, margin: 1 })
    res.setHeader('Content-Type', 'image/png')
    res.send(png)
  })

  return r
}
```

### 12) `backend/src/routes/public.ts`

```ts
import { Router } from 'express'
import { PrismaClient } from '@prisma/client'
import crypto from 'crypto'

export default function publicRoutes(prisma: PrismaClient) {
  const r = Router()

  // Public card JSON (for the frontend public page)
  r.get('/:slug', async (req, res) => {
    const card = await prisma.card.findUnique({ where: { slug: req.params.slug } })
    if (!card) return res.status(404).json({ error: 'Not found' })
    // hide ownerId and internal fields
    const { ownerId, ...safe } = card as any
    res.json(safe)
  })

  // Track a view
  r.post('/:slug/view', async (req, res) => {
    const card = await prisma.card.findUnique({ where: { slug: req.params.slug } })
    if (!card) return res.status(404).json({ error: 'Not found' })
    const ua = req.headers['user-agent']?.toString()
    const ref = req.headers['referer']?.toString()
    const ip = (req.headers['x-forwarded-for'] || req.socket.remoteAddress || '').toString()
    const ipHash = crypto.createHash('sha256').update(ip).digest('hex').slice(0, 16)
    await prisma.viewEvent.create({ data: { cardId: card.id, userAgent: ua, referrer: ref, ipHash } })
    res.json({ ok: true })
  })

  return r
}
```

---

# Frontend dosyaları (`frontend/`)

### 13) `frontend/package.json`

```json
{
  "name": "gobiz-vcard-frontend",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start"
  },
  "dependencies": {
    "next": "14.2.5",
    "react": "18.3.1",
    "react-dom": "18.3.1"
  },
  "devDependencies": {
    "typescript": "^5.5.4",
    "@types/node": "^20.14.10",
    "@types/react": "^18.3.3",
    "@types/react-dom": "^18.3.0"
  }
}
```

### 14) `frontend/tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "forceConsistentCasingInFileNames": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve"
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
```

### 15) `frontend/next.config.mjs`

```js
/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: { appDir: true }
}

export default nextConfig
```

### 16) `frontend/Dockerfile`

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package.json package-lock.json* pnpm-lock.yaml* yarn.lock* ./
RUN npm install || true
COPY . .
EXPOSE 3000
CMD ["npm","run","dev"]
```

### 17) `frontend/app/layout.tsx`

```tsx
export const metadata = { title: "GoBiz-like vCard", description: "Starter SaaS for digital business cards" }
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="tr">
      <body style={{ fontFamily: 'system-ui, sans-serif', margin: 0 }}>{children}</body>
    </html>
  )
}
```

### 18) `frontend/app/page.tsx`

```tsx
'use client'
import { useState } from 'react'

const API = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000'

export default function Home() {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [token, setToken] = useState<string | null>(null)

  const login = async () => {
    const res = await fetch(`${API}/auth/login`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ email, password }) })
    const data = await res.json()
    if (data.token) {
      localStorage.setItem('token', data.token)
      setToken(data.token)
      window.location.href = '/dashboard'
    } else {
      alert(data.error || 'Login failed')
    }
  }

  return (
    <main style={{ padding: 24 }}>
      <h1>GoBiz benzeri vCard SaaS</h1>
      <p>Hızlı bir başlangıç için basit bir demo.</p>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8, maxWidth: 360 }}>
        <input placeholder="email" value={email} onChange={e=>setEmail(e.target.value)} />
        <input placeholder="şifre" type="password" value={password} onChange={e=>setPassword(e.target.value)} />
        <button onClick={login}>Giriş</button>
      </div>
      <p style={{ marginTop: 16 }}>Hesabınız yok mu? Postman ile <code>/auth/register</code> deneyin.</p>
    </main>
  )
}
```

### 19) `frontend/app/(dashboard)/dashboard/page.tsx`

```tsx
'use client'
import { useEffect, useState } from 'react'
const API = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000'

type Card = {
  id: string; slug: string; fullName: string; title?: string; company?: string; email?: string;
}

export default function Dashboard() {
  const [cards, setCards] = useState<Card[]>([])
  const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null

  useEffect(() => {
    if (!token) { window.location.href = '/'; return }
    fetch(`${API}/cards`, { headers: { 'Authorization': `Bearer ${token}` } })
      .then(r=>r.json()).then(setCards).catch(console.error)
  }, [token])

  return (
    <main style={{ padding: 24 }}>
      <h2>Kartlarım</h2>
      <a href="/cards/new">+ Yeni Kart</a>
      <ul>
        {cards.map(c => (
          <li key={c.id} style={{ marginTop: 12 }}>
            <strong>{c.fullName}</strong> — <a href={`/p/${c.slug}`} target="_blank">/p/{c.slug}</a>
          </li>
        ))}
      </ul>
    </main>
  )
}
```

### 20) `frontend/app/(dashboard)/cards/new/page.tsx`

```tsx
'use client'
import { useState } from 'react'
const API = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000'

export default function NewCard() {
  const [form, setForm] = useState<any>({ slug:'', fullName:'', title:'', company:'', email:'', phone:'', website:'', bio:'' })
  const token = typeof window !== 'undefined' ? localStorage.getItem('token') : null

  const submit = async () => {
    const res = await fetch(`${API}/cards`, {
      method: 'POST',
      headers: { 'Content-Type':'application/json', 'Authorization': `Bearer ${token}` },
      body: JSON.stringify(form)
    })
    const data = await res.json()
    if (!res.ok) return alert(data.error || 'Hata')
    window.location.href = '/dashboard'
  }

  const set = (k:string, v:string) => setForm((p:any)=>({ ...p, [k]: v }))

  return (
    <main style={{ padding: 24, display:'grid', gap:8, maxWidth:480 }}>
      <h2>Yeni Kart</h2>
      {['slug','fullName','title','company','email','phone','website','bio'].map(key => (
        <input key={key} placeholder={key} value={(form as any)[key]||''} onChange={e=>set(key, e.target.value)} />
      ))}
      <button onClick={submit}>Oluştur</button>
    </main>
  )
}
```

### 21) `frontend/app/(public)/p/[slug]/page.tsx`

```tsx
'use client'
import { useEffect, useState } from 'react'
import { useParams } from 'next/navigation'

const API = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000'

export default function PublicCard() {
  const params = useParams()
  const slug = params?.slug as string
  const [data, setData] = useState<any>(null)

  useEffect(() => {
    if (!slug) return
    fetch(`${API}/p/${slug}`).then(r=>r.json()).then(setData).catch(console.error)
    fetch(`${API}/p/${slug}/view`, { method: 'POST' }).catch(()=>{})
  }, [slug])

  if (!data) return <main style={{ padding: 24 }}>Yükleniyor...</main>

  return (
    <main style={{ padding: 24, display:'grid', gap:8 }}>
      <img src={data.avatarUrl || `https://api.dicebear.com/9.x/initials/svg?seed=${encodeURIComponent(data.fullName)}`} alt="avatar" width={96} height={96} />
      <h1>{data.fullName}</h1>
      <p>{data.title} {data.company ? `@ ${data.company}` : ''}</p>
      <p><a href={`mailto:${data.email}`}>{data.email}</a> • <a href={`tel:${data.phone}`}>{data.phone}</a></p>
      {data.website && <p><a href={data.website} target="_blank">{data.website}</a></p>}
      <p>{data.bio}</p>
      <p>Bu sayfa demo amaçlıdır.</p>
    </main>
  )
}
```

---

# Kısa kullanım notları / sık karşılaşılan hatalar

1. **Dosyaları oluştururken** Windows'ta `:` veya `?` gibi yasaklı karakterlerden kaçının. Yukarıdaki dosya isimleri Unix uyumlu.
2. `docker compose up` çalıştırmadan önce bulunduğunuz dizinin içinde `docker-compose.yml` olduğundan emin olun.
3. Eğer Docker kullanmıyorsanız backend'i manuel çalıştırmak için:

   * `cd backend`
   * `.env` dosyasını oluştur (`.env.example` kopyala ve DATABASE\_URL'ı local Postgres'a göre ayarla)
   * `npm i`
   * `npm run prisma:dev`
   * `npm run dev`
4. Frontend için:

   * `cd frontend`
   * `npm i`
   * `npm run dev`
5. `prisma migrate dev` sırasında DB hatası geliyorsa (bağlantı/ yetki/port), `.env` içindeki `DATABASE_URL`'ı güncelleyin.

---

Eğer istersen şimdi:

* Ben sana bu dosyaları tek tek `curl`/`cat` ile yerel makinede otomatik oluşturacak bir **bash script** hazırlayayım (hepsi otomatik yazılsın).
* Ya da istersen **Base64 encoded .zip** çıktısı verip, sen onu decode edip aç (daha büyük ve uzun çıktı olur).

Hemen hangi yolu istersin? (Ben otomatik script hazırlayayım isen, doğrudan bash script'i de buraya yapıştırırım.)
