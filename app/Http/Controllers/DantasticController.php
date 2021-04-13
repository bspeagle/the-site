<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DantasticController extends Controller
{
    public function index()
    {
        return view('dantastic');
    }
}
