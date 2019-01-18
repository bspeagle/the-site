<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class AirHornController extends Controller
{
    public function index()
    {
        $results = $this->_getRanks();
        return view('airhornRanks')
                ->with('ranks', $results);
    }

    private function _getRanks()
    {
        return DB::connection('airhorn')->select('SELECT  ID, lastModDT, playCount FROM AirHorn.users order by playCount desc limit 100');
    }
}
