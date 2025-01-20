<?php

namespace App\Providers;

use Dotenv\Dotenv;
use Illuminate\Support\Env;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
//        dd(collect(  $_ENV)->sortKeys()->toArray());
//        var_dump($_ENV);
//        dd(app( Dotenv::class)->load());
//        app(Env::class)->afterLoadingEnvironment(function ($args) {
//
//            dd($args);
//        });
        //
    }
}
