-- ===================================================================
-- HALLO DIGIBUCH - SEED DATA (FIXED VERSION)
-- Ünite: Hallo! (Selamlaşma)
-- Aktiviteler: 12 aktivite (Video + Diyalog + Eşleştirme + Oyunlar)
-- ===================================================================

DO $$
DECLARE
    v_unite_id INTEGER;
    v_aktivite_1_id INTEGER;
    v_aktivite_2_id INTEGER;
    v_aktivite_3_id INTEGER;
    v_aktivite_4_id INTEGER;
    v_aktivite_5_id INTEGER;
    v_aktivite_6_id INTEGER;
    v_aktivite_7_id INTEGER;
    v_aktivite_8_id INTEGER;
    v_aktivite_9_id INTEGER;
    v_aktivite_10_id INTEGER;
    v_aktivite_11_id INTEGER;
BEGIN

-- ===================================================================
-- ÜNITE OLUŞTUR
-- ===================================================================
INSERT INTO uniteler (
    baslik,
    aciklama,
    slug,
    icon,
    kapak_gorseli,
    arkaplan_gorseli,
    sira_no,
    toplam_puan,
    durum
) VALUES (
    'Hallo!',
    'Almanca selamlaşma ve tanışma ifadelerini öğren. Buzzy ve Beezy ile birlikte temel konuşma kalıplarını keşfet!',
    'hallo',
    '👋',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    1,
    155,
    'aktif'
) ON CONFLICT (slug) DO UPDATE SET
    baslik = EXCLUDED.baslik,
    aciklama = EXCLUDED.aciklama,
    toplam_puan = EXCLUDED.toplam_puan
RETURNING id INTO v_unite_id;

RAISE NOTICE 'Ünite oluşturuldu: ID = %', v_unite_id;

-- ===================================================================
-- AKTİVİTE 1: Video - Hallo! Ich bin Buzzy!
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_intro', 'video', 'Hallo! Ich bin Buzzy!',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/iXR6m1w5SUI?si=L6GB0D85v5IS87I-',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 1, NULL, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    baslik = EXCLUDED.baslik,
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_1_id;

RAISE NOTICE 'Aktivite 1 oluşturuldu: ID = %', v_aktivite_1_id;

-- ===================================================================
-- AKTİVİTE 2: Buzzy Beezy Listen - Hör zu (Diyalog)
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_buzzy_beezy_listen', 'buzzy_beezy_listen', 'Hör zu.',
    '{
        "instruction": {
            "text": "Hör zu und klicke auf die Texte!",
            "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}
        },
        "parts": [
            {
                "id": "part1",
                "partNumber": 1,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-1-gorseli.png",
                "dialogue": [
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Hallo!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-1.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-1-hallobuzzy.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Hallo!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-1-1.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-1-hallobezzy.mp3"}}
                    }
                ]
            },
            {
                "id": "part2",
                "partNumber": 2,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-gorseli.png",
                "dialogue": [
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Hallo! Ich heiße Buzzy. Wie heißt du?",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-buzzy-1.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Hallo! Ich heiße Beezy.",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-bezzy-2.mp3"}}
                    },
                    {
                        "character": "buzzy",
                        "position": "bottom",
                        "text": "Freut mich, auch!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-3.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-buzzy-3.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "bottom",
                        "text": "Freut mich!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-2-4.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-2-bezzy-4.mp3"}}
                    }
                ]
            },
            {
                "id": "part3",
                "partNumber": 3,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3-gorseli.png",
                "dialogue": [
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Wie geht es dir?",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-3-bezzy-1.mp3"}}
                    },
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Gut. Danke! Und dir?",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-3-buzzy-2.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "bottom",
                        "text": "Es geht mir super!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-3-3.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-3-bezzy-3.mp3"}}
                    }
                ]
            },
            {
                "id": "part4",
                "partNumber": 4,
                "totalParts": 4,
                "visualImage": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-4-gorseli.png",
                "dialogue": [
                    {
                        "character": "buzzy",
                        "position": "top",
                        "text": "Tschüs!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-4.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-4-buzzy-1.mp3"}}
                    },
                    {
                        "character": "beezy",
                        "position": "top",
                        "text": "Auf Wiedersehen!",
                        "imageUrl": "https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/diyalog-4-2.png",
                        "audio": {"storage": {"bucket": "audio", "path": "hallo/etkinlik-1/diyalog-4-bezzy-2.mp3"}}
                    }
                ],
                "isFinal": true
            }
        ]
    }',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Hör zu und klicke auf die Texte!","audio":{"storage":{"bucket":"audio","path":"hallo/etkinlik-1/etkinlik-1-sorusu.mp3"}}}',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    40, 2, v_aktivite_1_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    baslik = EXCLUDED.baslik,
    icerik = EXCLUDED.icerik
RETURNING id INTO v_aktivite_2_id;

RAISE NOTICE 'Aktivite 2 oluşturuldu: ID = %', v_aktivite_2_id;

-- ===================================================================
-- AKTİVİTE 3: Video - Wie heißt du?
-- ===================================================================
INSERT INTO aktiviteler (
    unite_id, aktivite_id, tip, baslik,
    icerik, arkaplan_gorseli, yonerge_ses, video_url,
    ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
) VALUES (
    v_unite_id, 'hallo_video_page_3', 'video', 'Wie heißt du? Buzzy!',
    '{"instruction":{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}}',
    'https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/arkaplan.png',
    '{"text":"Schau dir das Video an und lerne die Begrüßungen!","audio":{"storage":{"bucket":"audio","path":"hallo/instructions/video-1.mp3"}}}',
    'https://www.youtube.com/embed/Kooa4eScQ10?si=FLx5gw_bDpo7HYih',
    '{"soundButton":"https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/hallo-etkinlik-1/soru-ses-butonu.png"}',
    0, 3, v_aktivite_2_id, 'aktif'
)
ON CONFLICT (unite_id, aktivite_id) DO UPDATE SET
    baslik = EXCLUDED.baslik,
    video_url = EXCLUDED.video_url
RETURNING id INTO v_aktivite_3_id;

RAISE NOTICE 'Aktivite 3 oluşturuldu: ID = %', v_aktivite_3_id;

-- DEVAMI SONRAKI MESAJDA (karakter limiti)

RAISE NOTICE '✅ HALLO ÜNİTESİ VE İLK 3 AKTİVİTE BAŞARIYLA OLUŞTURULDU!';

END $$;
