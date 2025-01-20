<?php

use App\Models\User;
use Illuminate\Foundation\Http\Middleware\VerifyCsrfToken;
use function Pest\Laravel\assertDatabaseHas;
use function PHPUnit\Framework\assertNotNull;

beforeAll(function () {
//    dd(collect(  $_ENV)->sortKeys()->toArray());
});

beforeEach(function () {
    assert(config('database.default') === 'sqlite', var_export( $_ENV, true));
    assert(config('app.env') === 'testing', );
});

test('login screen can be rendered', function () {
    $response = $this->get('/login');

    $response->assertStatus(200);
});

test('users can authenticate using the login screen', function () {
    $user = User::factory()->create();

    assertNotNulL($user);
    assertDatabaseHas('users', \Illuminate\Support\Arr::except($user->toArray(), [
        'profile_photo_url',
        'email_verified_at',
        'created_at',
        'updated_at',
    ]));

    $response = $this
        ->withoutMiddleware(VerifyCsrfToken::class)
        ->post('/login', [
        'email' => $user->email,
        'password' => 'password',
    ]);

    $this->assertAuthenticated();
    $response->assertRedirect(route('dashboard', absolute: false));
});

test('users cannot authenticate with invalid password', function () {
    $user = User::factory()->create();

    $this->withoutMiddleware(VerifyCsrfToken::class)
        ->post('/login', [
        'email' => $user->email,
        'password' => 'wrong-password',
    ]);

    $this->assertGuest();
});
