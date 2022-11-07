using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
public class PivotExtent
{
    public Vector3 dir;
    public float length;
}
public class Pivot
{
    public bool invalid = false;
    public Vector2Int pixelCoord;
    public int level;
    public Vector3 pos;
    public uint index;
    public uint parentIndex;
}
public class PivotDebuger : MonoBehaviour
{
    [Range(0, 10)]
    public int showLevel = 0;

    Dictionary<Vector2Int, Pivot> dictPivots = new Dictionary<Vector2Int, Pivot>();
    public bool drawGizmos = true;
    public Texture2D pivotTexture;
    public Texture2D extentTexture;
    public float unitScale = 0.01f;
    public float gizemoSize = 0.1f;
    public List<Pivot> pivots = new List<Pivot>();
    public List<PivotExtent> extents = new List<PivotExtent>();
    // Start is called before the first frame update
    void Start()
    {

    }

    uint UnpackIntegerAsFloat(float integerAsFloat)
    {

        byte[] raw = System.BitConverter.GetBytes(integerAsFloat);
        uint uRes32 = System.BitConverter.ToUInt32(raw, 0);

        uint sign2 = ((uRes32 >> 16) & 0x8000);
        uint _exp2 = (uint)(((((int)((uRes32 >> 23) & 0xff)) - 127 + 15) << 10));
        uint mant2 = ((uRes32 >> 13) & 0x3ff);
        uint bits = (sign2 | _exp2 | mant2);
        uint result = bits - 1024;
        return result;
    }

    Vector2Int getCoord(uint index)
    {
        return new Vector2Int((int)index % pivotTexture.width, pivotTexture.height - (int)index / pivotTexture.width - 1);
    }
    // Update is called once per frame
    public void OnValidate()
    {
        if (!drawGizmos)
            return;
        int w = pivotTexture.width;
        int h = pivotTexture.height;
        dictPivots.Clear();
        pivots.Clear();
        extents.Clear();
        if (pivotTexture != null)
        {

            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                {
                    var p = pivotTexture.GetPixel(x, y);

                    var pv = new Pivot();
                    if (p.r == 0 && p.g == 0 && p.b == 0 && p.a == 0)
                    {
                        pv.invalid = true;
                    }

                    pv.pos = new Vector3(-unitScale * p.r, unitScale * (p.b), unitScale * p.g);
                    pv.parentIndex = UnpackIntegerAsFloat(p.a);
                    uint pindex = pv.parentIndex;
                    pv.pixelCoord = new Vector2Int(x, y);
                    var flipped_y = h - y - 1;
                    pv.index = (uint)(x + flipped_y * w);
                    pivots.Add(pv);
                    dictPivots.Add(pv.pixelCoord, pv);

                }
            }


            for (int i = 0; i < pivots.Count; i++)
            {
                var p = pivots[i];
                var op = p;
                while (p.index != p.parentIndex)
                {
                    op.level++;
                    if (op.level > showLevel)
                        break;

                    //look for pixel
                    if (!dictPivots.TryGetValue(getCoord(p.parentIndex), out p))
                        break;

                }
            }


        }

        if (extentTexture != null)
        {
            for (int y = 0; y < h; y++)
            {
                for (int x = 0; x < w; x++)
                {
                    var p = extentTexture.GetPixel(x, y);
                    // if ( p.r == 0 && p.g == 0 && p.b == 0 && p.a == 0 )
                    //     continue;
                    var ext = new PivotExtent();
                    ext.dir = new Vector3(-(p.r - 0.5f), (p.b - 0.5f), p.g - 0.5f);
                    ext.dir *= 2.0f;
                    ext.length = p.a * 2048 * unitScale;
                    extents.Add(ext);

                }
            }
        }
    }




    void OnDrawGizmos()
    {

        if (!drawGizmos)
            return;
        for (int i = 0; i < pivots.Count; i++)
        {
            if (pivots[i].level > showLevel || pivots[i].invalid )
                continue;

            Gizmos.DrawSphere(transform.TransformPoint(pivots[i].pos), gizemoSize);
            Gizmos.DrawLine(transform.TransformPoint(pivots[i].pos), transform.TransformPoint(pivots[i].pos + extents[i].dir * extents[i].length));
            // 
            // {0}  ({1},{2})  [{3}]  [{4}] [{5}]
            var labelText = string.Format("Level:{6}", pivots[i].index, pivots[i].index % pivotTexture.width,
            pivots[i].index / pivotTexture.width, pivots[i].parentIndex, pivots[i].pos, extents[i].dir, pivots[i].level);
            Handles.Label(transform.TransformPoint(pivots[i].pos), labelText);
        }
    }
}
