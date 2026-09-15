extends Node2D

const SAVE_PATH := "user://magic_shoe_save.json"
const SPEED := 260.0
var player := Vector2(640, 540)
var shoe := Vector2(980, 220)
var puzzle := Vector2(350, 300)
var secret := Vector2(760, 420)
var has_shoe := false
var puzzle_done := false
var secret_found := false
var stars := 0
var message := "استكشف المكان وابحث عن الأثر الأول."
var t_up := false
var t_down := false
var t_left := false
var t_right := false

func _ready() -> void:
    load_progress()
    queue_redraw()

func _process(delta: float) -> void:
    var d := Input.get_vector("move_left", "move_right", "move_up", "move_down")
    d += Vector2(float(t_right) - float(t_left), float(t_down) - float(t_up))
    if d.length() > 0.0:
        player += d.normalized() * SPEED * delta
        player.x = clamp(player.x, 80.0, 1200.0)
        player.y = clamp(player.y, 150.0, 585.0)
    if Input.is_action_just_pressed("interact"):
        interact()
    queue_redraw()

func _input(event: InputEvent) -> void:
    var p := Vector2.ZERO
    var down := false
    if event is InputEventScreenTouch:
        p = event.position
        down = event.pressed
    elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        p = event.position
        down = event.pressed
    else:
        return
    if down:
        t_up = Rect2(105, 575, 70, 55).has_point(p)
        t_down = Rect2(105, 645, 70, 55).has_point(p)
        t_left = Rect2(30, 610, 70, 55).has_point(p)
        t_right = Rect2(180, 610, 70, 55).has_point(p)
        if Rect2(1110, 590, 110, 90).has_point(p):
            interact()
    else:
        t_up = false
        t_down = false
        t_left = false
        t_right = false

func interact() -> void:
    if not puzzle_done and player.distance_to(puzzle) < 100.0:
        puzzle_done = true
        stars += 1
        message = "أحسنت! حُلّ اللغز الأول. اتبع النجوم إلى الحذاء."
        save_progress()
    elif puzzle_done and not has_shoe and player.distance_to(shoe) < 100.0:
        has_shoe = true
        message = "وجدت الحذاء السحري! ✨ الخطوة الخفية أصبحت متاحة."
        save_progress()
    elif has_shoe and not secret_found and player.distance_to(secret) < 100.0:
        secret_found = true
        stars += 2
        message = "كشفت الخطوة الخفية طريقًا سريًا! +2 نجمة. مهمة العصا مفتوحة."
        save_progress()
    elif has_shoe:
        message = "مهمتك التالية: العثور على العصا السحرية."
    elif puzzle_done:
        message = "اقترب من الحذاء السحري واضغط تفاعل."
    else:
        message = "اقترب من حجر اللغز واضغط تفاعل."

func save_progress() -> void:
    var data := {"has_shoe": has_shoe, "puzzle_done": puzzle_done, "secret_found": secret_found, "stars": stars}
    var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if f:
        f.store_string(JSON.stringify(data))

func load_progress() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return
    var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if not f:
        return
    var data = JSON.parse_string(f.get_as_text())
    if data is Dictionary:
        has_shoe = data.get("has_shoe", false)
        puzzle_done = data.get("puzzle_done", false)
        secret_found = data.get("secret_found", false)
        stars = data.get("stars", 0)
        if secret_found:
            message = "الطريق السري مكتشف. مهمة العصا السحرية مفتوحة."
        elif has_shoe:
            message = "الحذاء معك. جرّب الخطوة الخفية."
        elif puzzle_done:
            message = "اللغز حُلّ. اتبع أثر النجوم إلى الحذاء."

func _draw() -> void:
    draw_rect(Rect2(0, 0, 1280, 720), Color("101827"), true)
    draw_rect(Rect2(50, 125, 1180, 480), Color("17263a"), true)
    draw_circle(Vector2(640, 380), 285, Color("1d2d43"))
    draw_string(ThemeDB.fallback_font, Vector2(50, 55), "الحذاء السحري", HORIZONTAL_ALIGNMENT_LEFT, -1, 36, Color("f4d58d"))
    draw_string(ThemeDB.fallback_font, Vector2(50, 88), "المغامرة الأولى — أثر يقود إلى سر", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("b9c7d9"))
    draw_string(ThemeDB.fallback_font, Vector2(965, 55), "النجوم: %d" % stars, HORIZONTAL_ALIGNMENT_LEFT, -1, 19, Color("f4d58d"))
    draw_string(ThemeDB.fallback_font, Vector2(965, 84), "الحذاء: ✓" if has_shoe else "الهدف: الحذاء السحري", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("9de3b2") if has_shoe else Color("d6dfeb"))
    if has_shoe:
        draw_string(ThemeDB.fallback_font, Vector2(965, 112), "مهمة العصا: مفتوحة", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("d6dfeb"))

    draw_circle(puzzle, 50, Color("475a72"))
    draw_circle(puzzle, 35, Color("26364d"))
    draw_string(ThemeDB.fallback_font, Vector2(340, 310), "؟", HORIZONTAL_ALIGNMENT_LEFT, -1, 34, Color("f4d58d"))
    draw_string(ThemeDB.fallback_font, Vector2(315, 378), "حجر اللغز", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("d6dfeb"))
    for pos in [Vector2(520,255), Vector2(700,235), Vector2(850,225)]:
        draw_circle(pos, 10, Color("f4d58d"))

    if not has_shoe:
        draw_circle(shoe, 58, Color("6b4ea2"))
        draw_string(ThemeDB.fallback_font, Vector2(shoe.x-42, shoe.y+8), "حذاء", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("ffffff"))
        draw_string(ThemeDB.fallback_font, Vector2(shoe.x-78, shoe.y+82), "الحذاء السحري", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("f4d58d"))
    else:
        draw_circle(shoe, 48, Color("30445b"))
        draw_string(ThemeDB.fallback_font, Vector2(shoe.x-15, shoe.y+10), "✓", HORIZONTAL_ALIGNMENT_LEFT, -1, 34, Color("9de3b2"))

    if has_shoe and not secret_found:
        draw_circle(secret, 42, Color("3f6b72"))
        draw_string(ThemeDB.fallback_font, Vector2(secret.x-30, secret.y+8), "سر", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("9de3b2"))
        draw_string(ThemeDB.fallback_font, Vector2(secret.x-55, secret.y+65), "طريق خفي", HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("b9c7d9"))
    elif secret_found:
        draw_circle(secret, 42, Color("30445b"))
        draw_string(ThemeDB.fallback_font, Vector2(secret.x-16, secret.y+8), "+2", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("9de3b2"))

    draw_circle(player, 28, Color("e7edf5"))
    draw_circle(player, 19, Color("607b9f"))
    draw_string(ThemeDB.fallback_font, Vector2(player.x-10, player.y+7), "✦", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f4d58d"))

    draw_rect(Rect2(35, 625, 1210, 48), Color("0b111c"), true)
    draw_string(ThemeDB.fallback_font, Vector2(60, 656), message, HORIZONTAL_ALIGNMENT_LEFT, 1030, 19, Color("ffffff"))

    draw_circle(Vector2(140,612), 38, Color("26384f"))
    draw_circle(Vector2(140,675), 38, Color("26384f"))
    draw_circle(Vector2(65,644), 38, Color("26384f"))
    draw_circle(Vector2(215,644), 38, Color("26384f"))
    draw_string(ThemeDB.fallback_font, Vector2(130,620), "↑", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("ffffff"))
    draw_string(ThemeDB.fallback_font, Vector2(130,684), "↓", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("ffffff"))
    draw_string(ThemeDB.fallback_font, Vector2(55,653), "←", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("ffffff"))
    draw_string(ThemeDB.fallback_font, Vector2(205,653), "→", HORIZONTAL_ALIGNMENT_LEFT, -1, 28, Color("ffffff"))
    draw_circle(Vector2(1165,645), 48, Color("6b4ea2"))
    draw_string(ThemeDB.fallback_font, Vector2(1140,653), "تفاعل", HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("ffffff"))
